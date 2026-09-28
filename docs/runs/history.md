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
