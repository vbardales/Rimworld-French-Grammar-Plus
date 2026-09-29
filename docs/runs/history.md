# Runs, one line each

Newest last. The evidence itself is never kept as folders: only the latest report that still proves
something stays on disk (`Tests/Pickle/Evidence/`, ignored by git). A run that needs more than a line gets
a file next to this one. See "What to keep after a test" in `TESTING.md`.

No Pickle run has been played for this mod: it has no Pickle suite yet, and nothing has been run in a game.
The lines below are offline runs, which start no game, and are marked as such.

- 2026-09-13, offline, on `9a83d86` plus the uncommitted corrections of that day: `_tools/Run-Tests.ps1`, 33 of 33 passed; `dotnet build` clean; `Check-DefInjected` 2 keys, 0 errors. Full output in `Tests/automated-2026-09-13.txt`, hashes in `Tests/artifact-sha256.json`.
- 2026-09-28, offline, on `ab7e776` (delivered DLL SHA-256 `DE2793A5...`, rebuilt from the sources to the same hash): 33 of 33 passed; `Check-DefInjected`, `Check-XmlFields`, `Check-DefRefs`, `Check-TypeRefs` and `Check-ConfigErrors` all clean. Nothing played in a game.
- 2026-09-28, offline, after the rename to `nelim.frenchgrammar` (delivered DLL SHA-256 `32876E61...`): 33 of 33 passed, the five checkers clean again, Workshop preview recomposed (452,100 bytes, contrast minimum 7.21). Nothing played in a game.
- 2026-09-28, offline, after adding two aspirated-h words (list at 78 entries; the delivered DLL is unchanged, 32876E61...): 33 of 33 passed. The two new shield cases were seen to fail on a copy without hachis, naming the word. Nothing played in a game.
- 2026-09-28, offline, after renaming the repository to Rimworld-French-Grammar-Renew (About.xml link only; the delivered DLL is unchanged): 33 of 33 passed. Nothing played in a game.
- 2026-09-28, offline, after dropping the `hall` prefix (77 entries; the delivered DLL is unchanged): 33 of 33 passed. Both negative tests gained hallucination, hallucinogene and hallux and were seen to fail with the prefix put back. Nothing played in a game.
- 2026-09-28, offline, Pickle suite written (seven features, four passes planned; not played): the step project builds with 0 warnings, `Check-Steps.ps1` compiles 120 patterns with none invalid or duplicated, `_tools/Run-Tests.ps1` 33 of 33. Nothing played in a game, no request filed yet.
- 2026-09-28 17:10, pass 1 French minimal, request 20260928-140036-944-e88b, tree of 5064be6: **31 passed, 0 failed, 3 skipped of 34**, exitReason passed. The 3 skipped are feature 07 (RIMMSQOL), which this pass does not load: unproven, not passed, and now excluded from passes 1 and 2 by filter. The two @review captures (settings page from the shortcut and from Mod options) were opened: French page reads correctly, no clipped text. Kept: summary, junit, messages, Player.log, two JPEG captures. Passes 2, 3, 4 filed as d0fb, 05b4, 63f2.
- 2026-09-29 13:49, pass 2 English minimal, request `20260928-191312-686-d0fb`, tree `076661b`: **11 passed, 1 failed, 0 skipped of 12**, exit 1. The failure was the step's own bug, not the mod's: `AssertSpeciesArticle` compared the raw text against the article, but the game wraps a species label in a `<color=…>` tag the step never stripped, so a correctly-untouched English "the megaspider" read as starting with `<color=` and failed. Fixed in `Tests/Pickle/Source/GrammarSteps.cs`: strip a leading colour tag before the check. Kept: summary, junit, messages, Player.log, three JPEG captures (two settings pages, the failing step). Re-filed as pass 2b below.
