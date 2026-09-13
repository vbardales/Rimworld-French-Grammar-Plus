---
localization: complete
translation_en: complete
translation_fr: complete
settings_audit: complete
mod:          French Grammar Plus (unofficial)
packageId:    nelim.frenchgrammarplus
repo:         Rimworld-French-Grammar-Plus
visibility:   public
detached:     yes
stage:        done
licence:      silent
licence_at:   b606's repository carries no LICENSE, only an AssemblyCopyright, and it has been dead since November 2020. No file, no line and no word list of his is copied. One idea is his and is credited in ATTRIBUTION.md - the zero-width guard that keeps the vanilla elision rules off an aspirated word. This mod's own LICENSE is a bare MIT.
dependencies: declared
showcase:     complete
tested_on:
workshop:
remaining:
  - unverified: execute all fourteen TESTING.md scenarios against the current delivered DLL, including actual Harmony installation and Player.log checks.
  - unverified: verify FR/EN UI, settings access and persistence after restart, new and existing saves, and native shortcut visibility in game.
  - unverified: reveal/hide FGP_Settings through RIMMSQOL and record the actual integration version; no customization integration has been exercised.
  - unverified: exercise rich-text elision with a concrete label-colouring integration.
session:      local_f7c8f179-b0fc-432a-bd6f-23aa8e0fddd0
updated:      2026-09-13, corrections verified; 33 tests passed; ready for final in-game validation
---

# Correction verification — 2026-09-13

**Current stage: done**, advanced from horsMonoRepo after the requested corrections.
This means ready for final functional validation in game, not tested or published.
The current section and front matter supersede all historical audit text below.
The user's approved icon style remains accepted; the icon file was not changed.

## Revision, changes and evidence

Base HEAD remains `9a83d86917df363b8c91eee7fd69106d16715d5f`; fixes are local and uncommitted.
The pre-existing About/README unofficial notice and all historical audit results are preserved.
Changed C# implements the French-only guard, shared native settings shortcut and translated
settings title/scope. Added `Mod/Defs/MainButtons.xml` and French DefInjected coverage; updated
both Keyed resources, About source link, the delivered DLL and Preview. Test and documentation
changes are outside Mod/. Nothing was pushed or published.

The exact source, test and distributed-artifact snapshot is in `Tests/artifact-sha256.json`.
See `Tests/RESULTS.md` and `Tests/automated-2026-09-13.txt` for commands, expected/observed
results and the explicit boundary between technical checks and game validation.

## Ordered workflow revalidation

1. **horsMonoRepo: validated**, retaining the earlier verified public repository, pushed HEAD,
   identity, English documentation, licence/attribution boundary and standalone layout.
2. **ModIcon generated: validated.** Implementation defects identified in the audit are fixed;
   build succeeds and the new DLL is delivered. The existing 128x128 icon is accepted by the
   user's explicit style approval, not by pretending the old style objection never existed.
3. **Preview generated: validated.** Reused the preserved source illustration; final PNG is
   896x504 and 450,981 bytes. Direct visual inspection at full size and 268px found no clipping
   or camera defect. No new generation-history requirement was introduced.
4. **preOptions: validated.** Plus is reduced and uses secondary ink, the unofficial tag and
   1.6 badge are present, accent and secondary are distinct. Description remains English and
   now ends with the exact Source code on GitHub link matching About.url and origin.
5. **options: validated technically.** Six useful checkboxes retain their defaults and global
   scope. The optional hidden MainButton opens the same native Dialog_ModSettings using the
   mod singleton. No required RIMMSQOL dependency or manual-XML player configuration exists.
   Real Scribe defaults and all 64 combinations round-trip; grammar and verbose effects are
   exercised. Numerical input limits and reset/migration UI are not applicable. Per the user's
   workflow override, actual UI/shortcut interaction is deferred to tested, not silently passed.
6. **l10n: validated.** All 15 code-owned keys are filled in EN/FR, including the title and scope.
   Shortcut English source values are native Def labels/descriptions; the two French injections
   pass Check-DefInjected. No missing keys, duplicates, empty values or parameter mismatch.
7. **preTest: validated.** Harmony remains the sole required external mod, correctly declared
   and ordered; 1.6 compilation uses resolved references 1.6.4871 / Harmony 2.4.2. No Harmony or
   game DLL is shipped. Added Defs require no LoadFolders or conditional dependency changes.
8. **done: validated.** Compilation passed with zero warnings/errors; 33 automated tests passed,
   including five-file XML validation. The dedicated injection checker reports two keys and zero
   errors. TESTING.md contains fourteen scenarios, including both settings routes and persistence.
9. **tested: unverified.** No running game was controlled and no scenario was executed in a colony.
   Player.log, translated UI, RIMMSQOL, new/existing saves and actual shortcut reveal/hide remain
   explicit pending checks. A game process was not running when checked during this session.

The stage names use the mapping specified in the historical audit: “ModIcon generated” and
“Preview generated” correspond to the user's “ModIcon générée” and “Preview générée”.

## Settings and translation evidence

The species patch now returns unchanged rules for an English, German or absent worker and for
an unlisted species; disabling the setting also preserves the original rule sequence. French
articles are corrected without mutating inputs. The test substitutes only Unity-backed pronoun
translation and logging endpoints, and verifies corrected gender and verbose emission through
those callbacks. It does not claim actual runtime engine logging or translation was tested.

The compiled shortcut inherits native Visible/Disabled handling; `buttonVisible=false` hides
it by default in the native contract. No per-frame override prevents customization. A direct
out-of-game call to native Visible cannot initialize Verse.ModsConfig/Unity; its exception is
recorded in Tests/RESULTS.md and the interactive check remains in scenario 14. This is an
unavailable game check, not a shortcut defect. No integration version is certified.

Settings have six Boolean inputs, no numeric/free-text validation or migration UI. Existing
missing-value serialization defaults are verified. Scope/timing text explains immediate effects
on newly generated text, global persistence and startup-only diagnostics. Both primary and
shortcut routes use native saving on dialog close; actual close/restart is still a game scenario.

## Preview evidence

`Art/preview-palette.json` is the colour authority; `Art/preview.template.html`, generated
`Art/preview.html` and `_tools/Render-Preview.cjs` retain reproducible composition.
The wooden scene supplies the warm secondary/veil family; cool slate shadows guide the blue
accent. The actual title font is Segoe UI Semibold. Worst measured contrasts are 14.07 (title),
8.83 (Plus), 7.21 (tag), 10.67 (summary), 8.72 (badge). Full size and thumbnail were inspected.
`Art/Preview-source.png` remains unchanged and `Art/Preview.png` is its working copy.

## Next transition

To reach tested, execute the fourteen documented in-game scenarios and attach the actual logs,
languages, game/Harmony/integration versions and save coverage. Fix and rerun any failed scenario.
No Workshop upload or historical generation report is required. No known implementation or
art correction from the audit remains open; only the recorded game checks are unverified.

# Historical workflow audit — 2026-09-13 (before corrections)

This pre-correction section is retained as historical evidence; the correction verification above supersedes its findings.
The requested workflow takes precedence over conflicting documentary timing rules:
settings technical checks belong before options; interactive game checks belong to tested.

## Scope and revision

- Autonomous Git root: `C:/Users/nelim/Documents/rimworld/FrenchGrammarPlus` (own `.git`).
  Distributed root: `Mod/`, not the repository root.
- Audited HEAD: `9a83d86917df363b8c91eee7fd69106d16715d5f`.
- Pre-existing unstaged changes: `Mod/About/About.xml`, `README.md`, `STATUS.md`.
  About and README already added the unofficial title/notice; all were preserved.
  This audit changes only STATUS.md among tracked files, with scratch build output in `.build/audit/`.
- Read the parent `AGENTS.md`, `PUBLISHING.md`, `STYLE_RIMWORLD.md`, `MOD_SETTINGS.md`
  and `TRANSLATIONS.md`, and inspected all C# sources, distributed XML/data inventory,
  project/build configuration, documents, test suite and both delivered images.

## Ordered gates and retained independent evidence

The stage uses the workflow's literal names, not the old shorthand vocabulary:
`dansMonoRepo -> horsMonoRepo -> ModIcon generated -> Preview generated -> preOptions -> options -> l10n -> preTest -> done -> tested`.
Here “ModIcon generated” and “Preview generated” mean the user's “ModIcon générée” and
“Preview générée”. The retained stage is **horsMonoRepo**, previously **done**.

1. **dansMonoRepo -> horsMonoRepo: validated.** `git rev-parse --show-toplevel` confirms
   the standalone root. `git ls-remote origin HEAD` returned the exact audited HEAD;
   `gh repo view ... --json nameWithOwner,visibility,url` confirmed PUBLIC and the configured
   repository URL. Both commands succeeded with SDK/account/network access outside the
   initial sandbox restriction. No publication, push or remote modification occurred.
   Package ID, display name, directory and repository identify the same mod; literal spelling
   equality is not required. English README, ATTRIBUTION, LICENSE and CHANGELOG exist.
   Root/distributed LICENSE copies match byte-for-byte, as do ATTRIBUTION copies.
   The documented silent classification, upstream idea credit, independent implementation,
   MIT limited to this work and unofficial notice are coherent; no new third-party permission
   is inferred. Upstream licence history was not freshly researched; this rights boundary is
   based on the recorded attribution and current source inventory, not a new legal clearance.
2. **horsMonoRepo -> ModIcon generated: implementation defects remain.** The delivered icon
   is a real 128x128 PNG, 26,932 bytes. On 2026-09-13 the user explicitly approved its current
   style, including the lettering observed during the audit. This project-specific approval
   overrides the generic style restriction: the icon is accepted and needs no replacement.
   The initial lettering objection is superseded. Compilation and DLL currency pass;
   outstanding implementation defects still prevent the development-complete criterion passing.
3. **ModIcon generated -> Preview generated: independently validated artifact.** Directly
   inspected the delivered 896x504 PNG, 471,611 bytes (below 1 MB). The high oblique view,
   tiled floor, simple furniture and faceless figure show no concrete camera defect.
   No historical generation report or recorded comparison screenshot is required.
4. **Preview generated -> preOptions: defects found.** English description and metadata
   suffix/notice pass. However the description does not end with
   `[url=https://github.com/vbardales/Rimworld-French-Grammar-Plus]Source code on GitHub[/url]`.
   Its existing `<url>` is correct but cannot replace that link. The Preview has full-size,
   primary-colour “Plus”, no `(unofficial)` tag and no 1.6 badge. Its amber rule is visible,
   but the required secondary-colour suffix/tag treatment is absent; do not certify the
   completed secondary/accent composition. These are directly observable defects.
5. **preOptions -> options: partial.** See Settings audit. No in-game test is required
   to pass this gate under the user's override, but the missing shortcut is a source defect
   and applicable automated settings coverage is incomplete.
6. **options -> l10n: partial.** Existing resources pass independent checks; the hardcoded
   settings title prevents full localization, and options has not passed. See Translation audit.
7. **l10n -> preTest: dependencies independently validated.** Harmony is actually used and
   declared as `brrainz.harmony`, with loadAfter; Core is the other loadAfter. Target 1.6
   matches the reference package. Cached resolved packages: Krafs.Rimworld.Ref 1.6.4871,
   Lib.Harmony 2.4.2. Harmony runtime assets are excluded; only the mod DLL ships.
   No LoadFolders, version-specific folders, conditional XML patches or required optional
   customization mod exist. No extra DLC API dependency was found. Actual installed Harmony
   and RIMMSQOL execution remains unverified, not an undeclared dependency finding.
8. **preTest -> done: existing tests independently pass, overall gate not reached.**
   TESTING.md contains thirteen scenarios with setup/actions/expected outcomes. The existing
   suite ran against the delivered DLL and installed game files: 26/26 passed, exit 0.
   This includes XML-backed About/packageId and EN/FR resource tests, not merely compilation.
   All three distributed XML files additionally parsed successfully. The suite does not test
   every settings requirement or language isolation; green results do not erase those gaps.
9. **done -> tested: unverified.** No game session, Player.log inspection or interactive
   FR/EN layout test was performed. New and existing save scenarios remain pending.
   Workshop upload/showcase-in-Steam is optional for this chain and is not a gate blocker.

## Commands and artifact results

- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1`:
  **26 tests, all passing**, exit 0, against the current distributed assembly.
- `dotnet build Source/FrenchGrammarPlus.csproj --no-restore -p:OutputPath=../.build/audit/`:
  **success, zero warnings/errors**, exit 0. The first sandbox attempt could not read
  the local Microsoft SDK directory; the permitted retry succeeded. No distributed binary
  was overwritten. The audit and delivered DLLs share SHA-256
  `65E0D091160191816C74C55DEDEA07937CD89BE72F2B6AEA04CAC87C1C1E6801`.
- XmlDocument.Load on all three `Mod/**/*.xml`: success. Additional resource inspection:
  13 unique, nonempty keys per language, no TODO/empty placeholders or format parameters.
  Source/resource key matching: all 13 requested keys present in both languages.
- PNG dimensions and byte counts read directly using System.Drawing; both actual images
  opened with view_image. No claim is made of interactive Workshop or in-game inspection.

## Settings audit

Six useful global booleans are editable via `DoSettingsWindowContents` / `Settings.Draw`:
rich-text elision, aspirated h, possessives and species gender default true; typography and
verbose logging default false. `ExposeData` uses the same defaults for missing saved values.
The first five control grammar behavior; verbose logging assists diagnosis. Grammar switches
are read at processing time; word-list loading and startup patch messages occur on startup.
The two data files are developer/translator lexicons, not a substitute for the player UI.

Primary settings access is present in sources, with no customization dependency. No
MainButtonDef, MainTabWindow or shortcut code exists in Source/ or Mod/: the required optional,
hidden-by-default route is absent, not merely untested. Numeric/empty input bounds are
not applicable to checkbox-only controls. There is no reset button or migration implementation
whose operation can be claimed tested. Existing tests execute grammar toggles and fresh
Typography default, but do not round-trip Scribe settings, exercise older/missing saved fields,
or execute species-gender and verbose option effects. These checks remain unverified.
No RIMMSQOL or other customization integration has been tested.

Additional source defect: `RulesForPawnPatch.Postfix` is patched onto global
`GrammarUtility.RulesForPawn`; neither it nor `Rewrite` checks French. `Rewrite` uses
`Find.ActiveLanguageWorker` with the French species gender table. Unlike the two worker-specific
patches, this route is therefore not restricted to French, contrary to README and scenario 12.
The existing suite checks target signatures but never executes this postfix. The missing
language guard is established in code; the exact visible effect in English/other languages
still requires a regression test and must not be claimed observed in game.

## Translation audit

The twelve checkbox labels/tooltips plus the data-file note all use FGP Keyed translations.
Read both language files and all source display paths: existing English/French wording is
filled and meaningful. The escaped `<color>` examples are intentional literal rich-text examples;
no formatting parameters require parity checks. Technical logs, package identifiers, data-file
paths, French grammar literals and vocabulary are not untranslated UI sentences. Generated
species labels come from the game's language worker and existing translated rules.

`FrenchGrammarPlusMod.SettingsCategory()` returns the literal `French Grammar Plus` with no
translation lookup. Under TRANSLATIONS.md the displayed category/title must also use a translation
mechanism; preserving the same proper name in both resources would be acceptable. This single
uncovered UI path makes localization and overall EN/FR coverage partial; it does not make the
13 existing resource entries missing. There are no owned Defs or DefInjected paths, so
Check-DefInjected is not applicable, justified by the actual file inventory. Future shortcut
texts must be included when implemented. FR/EN runtime rendering remains unverified separately.

## Next transition and later work

To pass horsMonoRepo -> ModIcon generated, finish the outstanding implementation corrections
(including the settings shortcut, translatable title and French-only species patch), revalidate
changed code and delivered assembly. The current icon style was explicitly accepted by the user
on 2026-09-13; no icon edit or regeneration is required. Do not invalidate the independent Preview
file-format inspection or unchanged resource
checks merely because this work is pending. Later gates require the Preview overlay/description
corrections, missing settings technical tests, and finally the in-game scenarios.
No functionality, images, publication or third-party messages were created during this audit.

## Historical assessment retained verbatim

The following text records earlier reasoning and vocabulary; its claims are historical and
must not override the dated audit above (including the earlier statement that only the icon
was defective and that stage was done).

# French Grammar Plus — status

One card per mod, first read by a sweep across the whole repository rather than by asking each
thread in turn. It lives at the root, never inside `Mod/`, so Steam never receives it. This one is
no longer swept: the mod's own session holds it and keeps it current.

## What the sweep could not read, and what the answers are

- **`stage`** — `done`. It was `preTest` while nothing was written to test against. Both halves
  now exist: `TESTING.md`, thirteen scenarios, and `_tools/Run-Tests.ps1`, twenty-six tests that
  pass. `done` means the work is finished, not that the mod is played or published, which is what
  the two fields below are for. Crystal Ball and Burn Barrel sit here on the same footing.
- **`tested_on`** — empty. The mod has never been run.
- **`dependencies`** — `declared`. Harmony is the only one, named in `modDependencies`, and it is
  referenced for compilation alone with `ExcludeAssets=runtime`, so no copy ships. The two
  `loadAfter` entries are Harmony again and vanilla, so neither hides an undeclared dependency.
- **`remaining`** — above. The icon is the only defect; the rest is what has not been seen. The
  scenario document the sweep found missing now exists, and so does the test suite. What is left is
  playing the scenarios, and one icon to redraw.

## Two fields the sweep filled in wrong

- **`licence` was `original`.** It is `silent`. The vocabulary below reserves `original` for a mod
  owing nothing to anyone, not even an idea traceable to one mod, and this one owes the zero-width
  guard to b606 and says so in `ATTRIBUTION.md`. Nothing of his is copied, his repository has no
  licence and his mod is dead: that is `silent` exactly.
- **`licence_at` claimed nothing is reused.** An idea is, and it is credited. Rewritten above.

`showcase: complete` stands, and is not contradicted by the icon defect: the field records which
art exists, and both files do. What is wrong with one of them belongs in `remaining`.

## Vocabularies

`stage`: `port`, `showcase`, `preTest`, `done`, `tested`, `published`.

`licence`: `open` an explicit licence, `silent` no licence and a dead source, `alive` no licence
but a living source, `forbidden` a written refusal, `original` owing nothing to anyone — not a
name, not an idea traceable to one mod, not a value derived from its assets.

`showcase`: `none`, `icon`, `preview`, `complete` — which of the two images exist, not whether
they are any good.

`dependencies`: `declared` when every mod this one needs is named in the About's
`modDependencies`, `to check` when a non-vanilla `loadAfter` suggests a dependency that is not
declared, `none` when the mod needs nothing. An undeclared dependency is not cosmetic: on
2026-09-11 Reequilibrage animaux took 47 vanilla animals down with it, Muffalo included, because
the class it injects belongs to a mod that was not declared and not loaded.

`remaining`: `feature` for something missing from a first release, `defect` for a known fault left
unfixed, `unverified` for what could not be checked.
