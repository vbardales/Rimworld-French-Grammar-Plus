# Verification results — 2026-09-13

Base commit: `9a83d86917df363b8c91eee7fd69106d16715d5f`, plus the uncommitted corrections
recorded in `artifact-sha256.json`. No game session or publication was performed.

| Check | Observed result |
| --- | --- |
| `dotnet build Source/FrenchGrammarPlus.csproj --no-restore` | Exit 0; zero warnings/errors; updated distributed DLL |
| `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1` | Exit 0; 33/33 tests passed; full output in `automated-2026-09-13.txt` |
| `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod ./Mod` | Exit 0; 11,587 Defs indexed, 2 keys checked, 0 errors |
| Distributed XML and Keyed inventory | Five XML files parse; 15 nonempty unique Keyed entries per language; no missing keys or mismatched parameters |
| MainButton translations | English label/description from the native Def; both French DefInjected paths resolve |
| Preview composition | 896x504 PNG, 450,981 bytes; full size and 268px thumbnail visually inspected |
| Preview contrast | Minimum measured over each text rectangle: title 14.07, suffix 8.83, tag 7.21, summary 10.67; badge 8.72 |
| Icon | Existing 128x128 PNG unchanged; current style explicitly approved by the user |

Distributed DLL SHA-256:
`DE2793A594515DD6DF17273330C138118154B54125AD558967BCE372F32AB942`.

## What the additional tests establish

- Fresh settings match the six documented defaults. Missing fields load their defaults and
  an unknown retired field is ignored. All 64 checkbox combinations round-trip through the
  real Scribe saver, XML file and `ExposeData` loading path into a new settings object.
- Species rules generate feminine French articles, preserve the original rule objects and
  pass through unchanged when disabled, when the worker is English/German/null or the species
  is unlisted. The possessive callback receives the corrected gender. Verbose output is
  emitted when enabled and ceases when disabled again.
- Tests execute the delivered rewrite logic with the real language workers and grammar-rule
  objects. Unity-backed pronoun translation and log output are explicit test callbacks;
  they do not validate engine rendering, actual Player.log writing or Harmony installation.
- The shortcut Def starts with `buttonVisible=false`, allows mapless use, resolves its real
  compiled worker and inherits native visibility/enabled-state behavior. The worker opens
  `Dialog_ModSettings` for the same mod singleton used by the primary settings route.
  Native dialog source inspection confirms it draws the mod's settings and calls
  `WriteSettings` on close. No separate configuration store or forced visibility override exists.

## Runtime boundaries and remaining scenarios

Directly invoking native `MainButtonWorker.Visible` outside the game cannot initialize
`Verse.ModsConfig`, which reads the running game's configuration via Unity. The attempted
check initially appeared false through PowerShell's property access; explicit reflection
exposed the type-initializer exception. It is an unavailable runtime check, not a discovered
shortcut defect. The final automated test checks the Def and compiled inheritance contract;
actual visibility/reveal/hide is explicitly part of scenario 14.

Similarly, the first species test reached Unity-backed `GenderUtility` texture initialization.
The final test substitutes only the engine pronoun/log endpoints, keeping the actual grammar
rewrite under test. Initial harness failures are not counted as successful game checks.

`TESTING.md` now contains fourteen functional scenarios. None has been executed in game in
this correction session. Remaining: startup patch installation/logs, FR/EN UI layout and
translation resolution, settings through both routes, restart/save persistence, new and existing
colonies, and a concrete rich-text label integration. RIMMSQOL and other customization tools
have **not** been exercised; no specific integration version is certified.

Checkbox-only input has no numerical boundaries or invalid text input. There is no reset
button, versioned settings migration or extra required optional dependency to test. Native
default-value loading is tested; interactive save/restart remains part of final validation.

## Art reproduction

`Art/Preview-source.png` is preserved, with a working copy at `Art/Preview.png`.
`Art/preview-palette.json` is the colour authority; `_tools/Render-Preview.cjs` generates
`Art/preview.html` from `Art/preview.template.html` and reads the version from About.xml.
Run `node _tools/Render-Preview.cjs` with Playwright and Sharp available via Node's module path.
Chrome is selected by `CHROME_PATH` or its standard Windows installation path.

The warm wooden desk guides secondary ink and veil; cool slate shadows guide the more saturated
blue accent. Segoe UI Semibold was confirmed via Chrome's platform-font report. The source
illustration is unchanged. Contrast is measured against the actual text-free rendered backdrop,
over whole text rectangles; the badge uses its opaque accent. Local QA files are under
`.build/preview-qa/`, including `thumbnail.png` and `results.json`.
