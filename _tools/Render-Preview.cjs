// Requires playwright and sharp. NODE_PATH may point to the installed package directory.
// The illustration is preserved; Chromium composes the editable HTML overlay specified by the workflow.
const fs = require('fs');
const path = require('path');
const { pathToFileURL } = require('url');
const { chromium } = require('playwright');
const sharp = require('sharp');
const root = path.resolve(__dirname, '..');
const art = path.join(root, 'Art');
const qa = path.join(root, '.build', 'preview-qa');
const palette = JSON.parse(fs.readFileSync(path.join(art, 'preview-palette.json'), 'utf8'));
const rgb = hex => hex.slice(1).match(/../g).map(x => parseInt(x, 16));
const lum = values => values.map(x => x / 255).map(x => x <= .04045 ? x / 12.92 : ((x + .055) / 1.055) ** 2.4).reduce((s,x,i) => s + x * [.2126,.7152,.0722][i], 0);
const contrast = (a,b) => (Math.max(a,b)+.05)/(Math.min(a,b)+.05);
const about = fs.readFileSync(path.join(root, 'Mod', 'About', 'About.xml'), 'utf8');
const versions = [...about.match(/<supportedVersions>([\s\S]*?)<\/supportedVersions>/)[1].matchAll(/<li>([\d.]+)<\/li>/g)].map(m => m[1]);
const version = versions.sort((a,b) => a.localeCompare(b, undefined, {numeric:true})).pop();
const vars = Object.entries(palette).map(([k,v]) => `--${k}: ${v};`).join('\n') + `\n--veilRgb: ${rgb(palette.veil).join(',')};`;
fs.mkdirSync(qa, { recursive: true });
const html = fs.readFileSync(path.join(art, 'preview.template.html'), 'utf8').replace('{{palette}}', vars).replace('{{version}}', version);
fs.writeFileSync(path.join(art, 'preview.html'), html);

(async () => {
  const browser = await chromium.launch({headless:true, executablePath:process.env.CHROME_PATH || 'C:/Program Files/Google/Chrome/Application/chrome.exe'});
  try {
    const page = await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
    await page.goto(pathToFileURL(path.join(art,'preview.html')).href);
    await page.evaluate(() => document.fonts.ready);
    const client = await page.context().newCDPSession(page);
    await client.send('DOM.enable'); await client.send('CSS.enable');
    const doc = await client.send('DOM.getDocument');
    const {nodeId} = await client.send('DOM.querySelector',{nodeId:doc.root.nodeId,selector:'.main-title'});
    const fonts = await client.send('CSS.getPlatformFontsForNode',{nodeId});
    const regions = await page.evaluate(() => ['.main-title','.suffix','.tag','.summary'].map(selector => {
      const el=document.querySelector(selector), r=el.getBoundingClientRect();
      return {selector,x:r.x,y:r.y,width:r.width,height:r.height};
    }));
    const output = path.join(root,'Mod','About','Preview.png');
    await page.screenshot({path:output});
    await page.addStyleTag({content:'.copy{visibility:hidden}'});
    const backdrop = await page.screenshot({path:path.join(qa,'backdrop.png')});
    const raw = await sharp(backdrop).removeAlpha().raw().toBuffer({resolveWithObject:true});
    const ratios = regions.map(r => {
      let worst=Infinity;
      const ink=lum(rgb(['.suffix','.tag'].includes(r.selector)?palette.inkSecondary:palette.inkPrimary));
      for(let y=Math.floor(r.y);y<Math.ceil(r.y+r.height);y++) for(let x=Math.floor(r.x);x<Math.ceil(r.x+r.width);x++) {
        const i=(y*raw.info.width+x)*raw.info.channels;
        worst=Math.min(worst,contrast(ink,lum([...raw.data.subarray(i,i+3)])));
      }
      return {...r,worstContrast:worst};
    });
    await page.reload(); await page.evaluate(() => document.fonts.ready);
    await page.addStyleTag({content:'body{transform:scale(0.299107142857);transform-origin:top left}html{width:268px;height:151px}'});
    await page.setViewportSize({width:268,height:151});
    await page.screenshot({path:path.join(qa,'thumbnail.png')});
    const result={version,fonts:fonts.fonts,regions:ratios,badgeContrast:contrast(lum(rgb(palette.accent)),lum(rgb(palette.badgeInk))),bytes:fs.statSync(output).size};
    fs.writeFileSync(path.join(qa,'results.json'),JSON.stringify(result,null,2)+'\n');
    console.log(JSON.stringify(result,null,2));
    if(result.bytes>=1000000 || ratios.some(r=>r.worstContrast<4.5) || result.badgeContrast<4.5) throw Error('Preview QA failed');
  } finally { await browser.close(); }
})().catch(e=>{console.error(e);process.exitCode=1});
