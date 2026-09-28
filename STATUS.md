---
localization: complete
translation_en: complete
translation_fr: complete
settings_audit: complete
mod:          French Grammar Renew (unofficial)
packageId:    nelim.frenchgrammar
repo:         Rimworld-French-Grammar-Renew
visibility:   public
detached:     yes
stage:        done
licence:      silent
licence_at:   b606's repository and Workshop item carry no licence (checked again on 2026-09-28), and the source has declared only RimWorld 1.0 to 1.2 since its last update on 2020-11-30. No file, no line and no word list of his is copied. One idea is his and is credited in ATTRIBUTION.md: the zero-width guard that keeps the vanilla elision rules off an aspirated word. This mod's own LICENSE is a bare MIT.
dependencies: declared
showcase:     complete
tested_on:
workshop:     3806761557 (0.1.0, creation of the publishIdFile only; Steam keeps every new item private, and switching it to public is the owner's)
remaining:
  - unverified: only pass 1 (French minimal) of the Pickle suite has been played: 31 passed, 0 failed, 3 skipped
    of 34 on tree `5064be6`, the two settings captures opened and read. The 3 skipped are the RIMMSQOL feature,
    unproven. Passes 2 (English), 3 (restart) and 4 (RIMMSQOL) are filed and not yet played.
  - unverified: what the suite does not assert, and says so in `Tests/Pickle/README.md`: a sentence the engine
    builds and displays, a real label that carries a colour tag, and the word lists reloading on restart.
  - unverified: the scenarios that passes 2, 3 and 4 cover (English isolation, restart, RIMMSQOL).
  - unverified: RIMMSQOL reveal and hide of the `FGP_Settings` shortcut; no customization integration
    has been exercised and no version is certified.
  - unverified: elision across a colour tag (scenario 9) cannot be played with the base game, since no
    vanilla French string carries a tag. It needs a mod that colours a label, and none is chosen.
  - feature: for `prepublished`, not yet started. No `PUBLICATION.md`; the description in `About.xml`
    lacks the `IF I GO QUIET`, `AI-GENERATED` and `THANKS` sections and the attribution line that
    AUDIT.md orders after the body; no thank-you comment for b606's page (2081845369, absent from the
    register); this mod is not yet in the `Covers` of the Harmony, Pickle, RimLogging and RIMMSQOL rows.
  - unverified: nothing has been uploaded since the 0.1.0 creation, so the page's description, gallery
    and change notes have never been seen in place.
session:      local_f7c8f179-b0fc-432a-bd6f-23aa8e0fddd0
updated:      2026-09-28, audited against AUDIT.md (protocols c5ca0c0 plus local edits); done -> preTest, then preTest -> done once the Pickle suite was written
---

# French Grammar Renew (unofficial): status

The session title is `frenchgrammar / done`: the packageId without `nelim.`, then the `stage`.

## Verdict, 2026-09-28

**`done`, reached the same day.** The stage codes of this sheet are the states of the AUDIT.md chain under the same
names. The audit of the morning found every state up to `preTest` established and `done` not, for one reason:
**the Pickle suite the workflow asks to be written did not exist.** It was written the same day, and `done` holds
again. The session title moved with it, `frenchgrammar / preTest` then `frenchgrammar / done`.

The previous audit (2026-09-13) had set `done`. Its text is archived unchanged in
`docs/audits/2026-09-13-status-sections.md`; what it says about the stage, the icon approval and the
workflow it quotes is superseded by this section.

### What `done` asks for, and where it stands

| Criterion (AUDIT.md, preTest -> done) | Verdict |
|---|---|
| Functional scenarios written with preconditions, actions and expected results | validated: fourteen in `TESTING.md` |
| Automated tests written, run and green | validated: 33 of 33, today, twice (before and after the rename) |
| **Pickle (Gherkin) tests written, their scope justified** | validated: seven features in `Tests/Pickle/`, the scope and what is left out justified in its `README.md`. Written, not played: execution is not asked at this step |
| XML tests written, run and green | validated: five checkers clean, all shipped XML parses |
| Non-applicability justified where claimed | validated: scenario 13, the German pass, the junk-line step and the real colour-tag label each carry their reason |
| Results match the delivered version | validated: the delivered DLL is what the sources build (below) |

## Ordered gates, 2026-09-28

Each verdict is what was checked today, not what an earlier sheet said.

1. **dansMonoRepo -> horsMonoRepo: validated.** Own git root, public GitHub repository, `origin/master` equal
   to the local head, STATUS.md present, licence `silent` justified and consistent, English documents,
   `LICENSE` and `ATTRIBUTION.md` byte-identical to their `Mod/` copies. Naming is coherent on purpose, not
   literally: `nelim.frenchgrammar`, `French Grammar Renew (unofficial)`, `Rimworld-French-Grammar-Renew`,
   `FrenchGrammarRenew`: all four now follow the name, the repository and the folder having been renamed on 2026-09-28.
   **New today: the origin's repository was looked at** (below) and the reason for not starting from it is in
   `ATTRIBUTION.md`.
2. **-> ModIcon generated: validated by the owner's decisions.** Build
   clean, the DLL current, `ModIcon.png` a 128 x 128 PNG of 26,932 bytes. Read at 32 px in a scratch copy
   (the file was not touched): the head, the book and the pen read; the bubble text, the book lettering and
   the flag do not. The owner approved that on 2026-09-13, and on 2026-09-28, asked about the bubble that
   says "plus" now that the mod is called Renew, she answered that the "Plus" suits her: the icon stays as it is.
   This audit generated, changed and asked nobody to generate anything.
3. **-> Preview generated: validated.** `Mod/About/Preview.png` is 896 x 504, 452,100 bytes (under 1 MB),
   opened and looked at: high oblique view, tiled floor, one lamp pool, a figure seen from behind, no face.
4. **-> preOptions: validated.** Accent (blue) and secondary ink (amber) are distinct; `Renew` is the suffix at
   65 % in the secondary ink, `(unofficial)` the tag, the version badge reads 1.6 as declared. The description
   is English, opens with the unofficial notice and ends with `[url=...]Source code on GitHub[/url]`.
5. **-> options: validated, technically.** Six checkbox settings, defaults documented and tested (all 64
   combinations round-trip through the real Scribe), primary access Mod options, hidden `FGP_Settings`
   shortcut (`buttonVisible` false) opening the same dialog. Interactive checks (reveal through RIMMSQOL,
   restart) are `tested` work, as AUDIT.md says. `MOD_SETTINGS.md` would call this `partial` while runtime
   tests remain; the audit prevails and `settings_audit` stays `complete`.
6. **-> l10n: validated.** Every player-facing string goes through `.Translate()` (the source was scanned; the
   `Log.*` lines are technical and English). 15 Keyed keys in English and French, none duplicated, empty or
   mismatched; the shortcut's label is the Def's English text with two French DefInjected paths;
   `Check-DefInjected` 2 keys, 0 errors. Re-run after the rename.
7. **-> preTest: validated.** Harmony is the only hard dependency, declared as `brrainz.harmony` with its
   Workshop link and in `loadAfter` with Core; the code uses it and ships none of it. No third-party type
   is referenced (`Check-TypeRefs`), no `LoadFolders`, no conditional patch. RIMMSQOL is an optional
   integration and correctly not declared.
8. **-> done: validated** (above), once the Pickle suite was written.
9. **-> tested: unverified.** Nothing was played. See "Next transitions".
10. **-> prepublished, 11. -> published: not started.** A `0.1.0` upload exists (below). It is an act, not a
    step of the chain: it neither advances nor implies `prepublished`.

## Revision and changes

- Audited: `ab7e776` (adds `PublishedFileId.txt` and the 0.1.0 entry) on top of `acf1b47`, plus the
  working-tree changes of this session, committed together with this sheet.
- **Renamed** on the owner's word, the repository (`Rimworld-French-Grammar-Renew`, the old address redirects) and the folder (`FrenchGrammarRenew`) included: name `French Grammar Renew (unofficial)` (was `French Grammar Plus`),
  packageId `nelim.frenchgrammar` (was `nelim.frenchgrammarplus`), following the collection's `Renew` for a mod
  that continues a dead one and the 2026-09-27 rule that the packageId carries neither `Renew` nor a suffix.
  Checked before changing it: the new id is free among the 126 mods of the collection; no save (29) and no
  active `ModsConfig.xml` names the old one (only old backups of it do). It touched `About.xml`, one constant in
  the C#, the settings title and shortcut label in both languages, the README and TESTING titles and
  `Art/preview.template.html`. The DLL was rebuilt and the Workshop preview recomposed with the existing
  renderer (the illustration is unchanged; only the suffix word differs). The `0.1.0` item still carries the
  old id and the old name until the next upload.
- **Wrote the Pickle suite** (`Tests/Pickle/`): seven features, four local step classes bound against the shipped
  DLL (built, 23,552 bytes, tracked), two pass maps, a README with the scope and what is left out, and
  `Check-Steps.ps1`, which compiles all 120 step patterns, the shared ones included, with Pickle's own expression
  engine (none invalid, none declared twice). Modelled on the Flavor Text Extended - Francais suite; the
  RIMMSQOL feature reuses the shared steps of `PickleTools/RimmsqolSteps` unchanged. Not played.
- Added `docs/PROTOCOLS-READ.md`, `BACKLOG.md`, `docs/runs/history.md`; archived the 2026-09-13 sections;
  wrote the `tested` criteria, the pass plan, the coverage map and the evidence rule into `TESTING.md`;
  wrote the provenance section into both `ATTRIBUTION.md` copies; refreshed `Tests/artifact-sha256.json`,
  whose `About.xml` and `Mod/LICENSE` entries were stale since the commits of 2026-09-20.
- `.gitignore` now also ignores `*.ico`, `*.dds` / `*.DDS` and the evidence folders. There was no `.dds` in
  the repository, tracked or not, and no test evidence anywhere; the two `.ico` files of the folder icons
  were untracked and now ignored.

## Checks run

| Check | Result |
|---|---|
| `_tools/Run-Tests.ps1` | 33 of 33, exit 0, before and after the rename |
| `dotnet build` to a scratch folder, before the rename | DLL SHA-256 `DE2793A5...`, **identical** to the delivered one |
| `dotnet build` of the renamed sources | delivered DLL SHA-256 `32876E61...`, the new id present in it and the old one absent |
| `Check-DefInjected`, `Check-XmlFields`, `Check-DefRefs`, `Check-TypeRefs`, `Check-ConfigErrors` | exit 0 each, before and after the rename |
| `Tests/artifact-sha256.json` against the disk | two entries stale, refreshed |
| Images | Preview 896 x 504, 452,100 B, contrast minima 14.07 / 8.83 / 7.21 / 10.67 and badge 8.72, thumbnail read at 268 px; ModIcon 128 x 128, 26,932 B, read at 32 px |
| Explorer folder icons | `desktop.ini` at the root and in `Mod/` point at `Art/ModIcon.ico` and `Art/Preview.ico`, which exist; attributes as required. `Art/Preview.ico` still shows the old suffix (local only) |
| Game | **not started, not touched.** No RimWorld was launched, no Pickle request filed |

## The original mod, looked at

`b606/RimWorld-LanguageWorker_French`: public, master, created 2020-03-25, last pushed 2020-11-30, not archived,
issues enabled and none open, no licence file, GitHub reports no licence, one fork (Elevator89's). Its Workshop
item (2081845369) was last updated 2020-11-30 (Steam manifest), declares 1.0, 1.1 and 1.2, and its shipped
files and README carry no licence wording. So it is `silent`. Starting from its repository was not possible
(no licence; a history not fit for publication) and a pull request would be a rewrite, not a correction; the
reasons are in `ATTRIBUTION.md`. **No issue or pull request has been sent**: that is public and is the
owner's to allow.

## The 0.1.0 upload

`Mod/About/PublishedFileId.txt` (3806761557, dated 2026-09-23) was untracked until today. Committed and pushed as
`Add published Workshop file ID for 0.1.0`, with a `## [0.1.0]` entry in `CHANGELOG.md` under the unreleased 1.0.0.
The upload carried `Mod/` as at `acf1b47`, apart from `desktop.ini`, which appeared on 2026-09-27, after it.
`Mod/desktop.ini` is ignored by git and would be sent by an upload from the game (`BACKLOG.md`).
No tag and no GitHub release were made for it.

## Next transitions

**`done` -> `tested`, the work now:** play the four passes of `TESTING.md` through the dispatcher, one request each, starting
with the French minimal pass. **Pass 1 played 2026-09-28 17:10: request `20260928-140036-944-e88b`, tree `5064be6`, 31 passed, 0 failed,
3 skipped (RIMMSQOL, not loaded by that pass), evidence in `Tests/Pickle/Evidence/2026-09-28-pass1-french`.** Filed after it, same tree:
pass 2 English `20260928-191312-686-d0fb`, pass 3 restart `20260928-191314-912-05b4`, pass 4 RIMMSQOL `20260928-191315-350-63f2`.
Then the conditions below.

**`done` -> `tested`, as `TESTING.md` now states:** no scenario left `@wip`; every conditional scenario has
run (the RIMMSQOL pass, with the report of each read; the colour-label and German passes are not planned, and why is in `TESTING.md`); no manual test
left to tick, each scenario either automated and green or listed not applicable with its reason; `@review`
captures opened; both languages; logs read. Keep only the evidence that still proves something.

## Reservations, not blockers

- **The `hall` prefix** was dropped on 2026-09-28, at the owner's "case by case": it caught `hallucination(s)`,
  `hallucinogene` and `hallux`, which take a mute h, so the mod wrote "la hallucination" where vanilla was right.
  The list has 77 entries, and both negative tests now know those words and were seen to fail with the prefix
  back. The loanword `hall` itself, aspirated, is no longer corrected: a handful of occurrences in the game's
  French text, to add back only when a real sentence needs it (`BACKLOG.md`).
- Two aspirated-h words, `hachis` and `harissa`, were added the same day, and the `Pluralize` finding is in
  `BACKLOG.md`. The latter was verified: the game's French worker returns `recettes` for a count of 1.

## Pointers

`TESTING.md`, `Tests/RESULTS.md`, `Tests/artifact-sha256.json`, `docs/runs/history.md`, `docs/PROTOCOLS-READ.md`,
`docs/audits/2026-09-13-status-sections.md`, `BACKLOG.md`, `CHANGELOG.md`.

## Vocabulary

`stage`: `port`, `showcase`, `preTest`, `done`, `tested`, `published`, matching the AUDIT.md states of the
same names. `licence`: `open`, `silent`, `alive`, `forbidden`, `original`. `remaining`: `feature` (missing),
`defect` (a known fault), `unverified` (could not be checked).
