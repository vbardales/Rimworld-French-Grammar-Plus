# Pickle suite of French Grammar Renew

Functional tests played by [Pickle](https://github.com/RimWorks/Rimworld-Pickle) in a real game. **Development
only, never published**: the companion mod sits in `Mod/`, beside the shipped mod's own `Mod/`, and the staging
copies it verbatim. **Nothing here has been played yet.** The suite was written on 2026-09-28 and its step
patterns compile against Pickle's own expression engine (`Check-Steps.ps1`); whether it passes is the first run.

The scenarios themselves are described in `../../TESTING.md` (fourteen, numbered). This file says what of them
a running game is needed for, and why the rest is not here.

## What needs a running game, and what does not

The offline suite, `_tools/Run-Tests.ps1`, runs the mod's own rules around the **game's own**
`LanguageWorker_French`, on strings, without starting the game. So the rules, the word lists against the game's
defs, the six settings and all 64 combinations round-tripped through the real `Scribe`, and the shortcut's Def and
worker contract are proved there and **not repeated in Gherkin**.

What only a game shows, and what this suite asserts:

| Feature | What a running game shows that the offline suite cannot |
|---|---|
| `01-loads` | Harmony really installed the three patches (asked of Harmony's own record, not of the log), a game loads with them with no error, and every text exists in the language of the pass |
| `02-french-grammar` | The **patched** worker of a running French game applies each correction, through the two entry points the engine calls, and a species keeps its own gender on a real pawn |
| `03-english-isolation` | The same worker, in a running English game, leaves everything alone |
| `04-settings` | The real `Dialog_ModSettings` opens through both routes and belongs to this mod; two `@review` captures of the page |
| `05` and `06` | The saved settings survive a real restart, in two processes |
| `07-rimmsqol-shortcut` | RIMMSQOL lists the hidden shortcut, reveals it, opens the same page, hides it |

## What is deliberately not here, and why

- **A sentence the engine builds and displays.** The steps prove the patched entry point, `PostProcessed` and
  `WithDefiniteArticle`, and the rules the game builds for a pawn. They do not read a letter or a tale back off
  the screen: no step in either catalogue triggers one and reads it, and writing that C# is the next step if the
  first run shows it is needed. It stays `unverified` in `STATUS.md`.
- **A real label that carries a colour tag** (TESTING.md, scenario 9). The rule is asserted on a string that
  carries the tag. Which mod colours a label is not chosen, so no pass mounts one.
- **Editing a shipped word list** (scenario 2's junk line, scenario 11's restart after removing a word). It
  changes a file of the mod under test; the offline suite proves the parsing rules instead.
- **A German pass.** The mod ships English and French, so a load audit in German would report missing keys by
  design. That the German worker is left alone is proved offline, with the game's own German worker.
- **Scenario 13**, adding and removing the mod in a running colony: the game's own behaviour, and the mod stores
  nothing in a save. Not applicable, with the reason in `TESTING.md`.
- **That a RIMMSQOL choice survives a restart.** It is RIMMSQOL's own storage. Only the reveal, the open and the
  hide are asserted for this mod.

## The passes

One pass is one request. Language passes are two launches, never a switch inside a scenario. The features that
only make sense in one language are left out of the other by name (`!term` excludes, and wins over a pick).
The restart pair is excluded from the bulk passes, because its reader run alone fails, which is right.

| # | Pass | Map | Filter |
|---|---|---|---|
| 1 | French, minimal | `wsl-deps.sans-facultatifs.map` | `'French Grammar Renew - Pickle tests,!03-english-isolation,!05-restart-write,!06-restart-read'` |
| 2 | English, minimal | `wsl-deps.sans-facultatifs.map` | `'French Grammar Renew - Pickle tests,!02-french-grammar,!05-restart-write,!06-restart-read'` |
| 3 | Restart | `wsl-deps.sans-facultatifs.map` | `'05-restart-write'` then `-Then '06-restart-read'`, French |
| 4 | RIMMSQOL | `wsl-deps.avec-rimmsqol.map` | `'07-rimmsqol-shortcut'`, French |

Passes 1, 2 and 4 in the other language are not planned: the layout of the page in English is read from pass 2's
captures. No pass exists for an incompatibility, none being declared.

**A run is filed, never launched.** From the collection root, with the session's own identifier:

```powershell
powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1 `
  -Mod FrenchGrammarRenew -Owner local_<id> -Label "pass 1 French <sha>" -Language French `
  -DepMap wsl-deps.sans-facultatifs.map `
  -Filter 'French Grammar Renew - Pickle tests,!03-english-isolation,!05-restart-write,!06-restart-read' `
  -EvidenceDir FrenchGrammarRenew/Tests/Pickle/Evidence/<date>-<pass>
```

A request carries no revision: the mod is staged when its ticket is played, from the working tree of that moment.
Keep `Mod/` and `Tests/` still until the run is done, and write the revision in the label.

## Layout

```
Tests/Pickle/
  README.md                       this file
  Check-Steps.ps1                 compiles every step pattern with Pickle's own engine; no game, two seconds
  wsl-deps.sans-facultatifs.map   ScreenshotMode and LoadAudit, development-only tools of PickleTools
  wsl-deps.avec-rimmsqol.map      RIMMSQOL, its Pickle steps and ScreenshotMode
  Source/                         the local steps: net48, bound against the shipped FrenchGrammarPlus.dll
  Mod/                            the test companion: About/About.xml, Pickle/Features, Pickle/Assemblies
```

`Mod/Pickle/Assemblies/FrenchGrammarRenew.PickleSteps.dll` is built from `Source/` and tracked, as the other suites
do; rebuild it after any change:

```powershell
dotnet build Tests\Pickle\Source\FrenchGrammarRenew.PickleSteps.csproj
powershell.exe -ExecutionPolicy Bypass -File Tests\Pickle\Check-Steps.ps1
```

Intermediates go to `.build/pickle/`, outside the companion, since the staging copies `Mod/` whole.

## Evidence

`Tests/Pickle/Evidence/` is on disk only and ignored by git. Keep, per pass, the summary, the JUnit file, the
messages, `Player.log` and the `@review` captures minified to JPEG; delete a report once a newer one replaces it
for the same revision; never delete one that `STATUS.md` points to. One text line per run goes to
`docs/runs/history.md`. The full rule is in `TESTING.md`, "What to keep after a test, and what to delete".
