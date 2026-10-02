# Protocol documents read for this mod

A log of what was read, at which version, and whether it was of use, so that a later session rereads a
document only when it has moved. "Version" is the last commit touching the file **in the repository that
holds it**. For the protocol documents that is `vbardales/Rimworld-protocols` (git dir
`../rimworld-protocols.git`, work tree the monorepo root), **not the monorepo**: `git log -1 -- AUDIT.md`
run from the monorepo answers with the commit that removed the file, a plausible hash for the opposite of
what is wanted (`Rimworld-Ticket-Dispatcher/docs/WELCOME.md`, section 5). The SHA-256 (first nine hex digits)
is given for files modified and not yet committed, since a commit hash cannot name them.

Read on 2026-09-28 and again on 2026-10-02 (`local_f7c8f179-b0fc-432a-bd6f-23aa8e0fddd0`). On 2026-10-02 the
documents that had moved were read as **diffs against the version of 2026-09-28** (or in full for `AUDIT.md`, which
grew from 246 to 277 lines); those that had not moved were not reread. Column "Read" says which.

## Protocols repository (`vbardales/Rimworld-protocols`)

| Document | Version on 2026-10-02 | Read | Useful for this mod |
| --- | --- | --- | --- |
| `AGENTS.md` | 7fd7475 (2026-09-29), was 3a1d2cb | in full (it is injected into the session) | yes: gate order, evidence retention, **publication by CI**; new: trim `docs/runs/history.md` once published (not yet: not published) |
| `AUDIT.md` | d1fdbe1 (2026-10-02), was c5ca0c0; sha256 `7c00eb1f3` | in full, 277 lines | yes: it is the workflow. New since 09-28: the session title rule (`<packageId sans nelim.> / <workflow_stage>`), the `workflow_stage` field, step 12 (what an audit replays for a `done` mod), the `tested` bullets (no `@wip`, conditional scenarios, no manual test left), the `0.1.0` as an act, WSL clean-up and branch clean-up at `published`. Its Pickle and machine sections only matter once a run is submitted |
| `MOD_SETTINGS.md` | b83933b (2026-09-23), unchanged | read on 2026-09-28, not reread | yes: this mod has settings and a hidden shortcut; the audit prevails over its `partial` |
| `TRANSLATIONS.md` | af8427f (2026-10-02), was f5c2d9d | diff read | yes: new rules of 2026-09-30, the `{PAWN_gender ? ... : ... : ...}` three-segment switch (not applicable here: no pawn text), the player-choice rule, **the systematic French review by the owner and `FRENCH_REVIEW.md`**. The plural rule of 09-25 was checked on 2026-10-02: no key of this mod takes a number |
| `PUBLISHING.md` | 4e8f11a (2026-10-02), was 95c6dfd; sha256 `c765bb3c7` | diff read | partly: **new: a pull request to an origin repository is systematic and goes in `BACKLOG.md`** (done), the gallery folder with `0-preview.png` a copy of the Preview (done: `Art/Gallery/0-preview.png`), the Preview typography and echo rules (not needed: nothing is generated). Not useful: the animal-mod integrations (this mod adds no animal), git sessions, CI details |
| `STYLE_RIMWORLD.md` | c105a43 (2026-10-01) plus uncommitted edits, sha256 `5a054cf3a`, was 7311308 | not reread: the parts used here (ModIcon *control*, the Preview) were read on 09-28 and the changes of 10-01 concern the generator, which this mod does not run | not for this audit |
| `WORKSHOP_COMMENTS.md` | 7fd7475 (2026-09-29), was dea856b | diff read | only at `prepublished`: **new: a "(Continued)" page is thanked once, on the Continued page, and the original author is credited in the same message**. b606's item (2081845369) is the original, so check its page for a maintainer before drafting. Still no row for it |
| `scripts/SEARCHING.md` | 50de695 (2026-09-28), same content (sha256 `013075b06`) | not reread | not for the audit; only for the backlog question about who else patches `LanguageWorker_French` |

## Other repositories

| Document | Version on 2026-10-02 | Read | Useful for this mod |
| --- | --- | --- | --- |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | 3c03f51 (2026-09-26), unchanged | not reread | partly (09-28): first publication of a mod, versions, change notes. Not useful: Steam credentials, semantic-release |
| `PickleTools/README.md` | ff20d89 (2026-09-29) plus edits, was c771bef | diff read (adds a pointer to `docs/FIXTURES.md`) | partly: the tool table. Fixtures are not needed: this mod plays on the default colony |
| `PickleTools/Headless/README.md` | ed4e73a (2026-09-26), unchanged | not reread | not needed until a run is submitted |
| `PickleTools/docs/steps.md` | da7c3b0 (2026-09-28) plus edits, was 96eda0f | not reread | only the sections of the tools this suite uses (`RimmsqolSteps`, `LoadAudit`, `KeyedClick`, `HoverSteps`, `InterfaceScale`, `ScreenshotMode`); the others are of no use |
| `PickleTools/Authoring/README.md` | a47799f (2026-09-29), was 8d3ca6d | diff read (fixtures pointer only) | yes (09-28): what needs a running game, the pass matrix, evidence. Lines 151-247 (waiting, timeouts, adding C#) remain unread, not needed |
| `PickleTools/TESTING.md` | 650adce (2026-09-25), unchanged | not reread | the "What to keep after a test" section is copied into this mod's `TESTING.md` |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | 77ca9d7 (2026-09-27), unchanged | not reread | yes (09-28): the reading list, the protocols git-dir trap, no Explorer artefact in `Mod/` |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | d07b2b8 (2026-09-26), unchanged | not reread | only to file a run; none is filed by this audit |

## This mod's own documents

| Document | Status on 2026-10-02 |
| --- | --- |
| `STATUS.md`, `README.md`, `CHANGELOG.md`, `TESTING.md`, `ATTRIBUTION.md`, `LICENSE`, `BACKLOG.md`, `Mod/About/About.xml`, `docs/runs/history.md` | read in full this session |
| `Tests/Pickle/README.md` | read in full |
| `PUBLICATION.md`, `NOTES.md`, `BUGS.md` | **do not exist.** `PUBLICATION.md` is due at `prepublished`; nothing belongs in the other two yet |
| `FRENCH_REVIEW.md` | generated by `scripts/Make-FrenchReview.ps1` (the mod's own `_tools/Generate-FrenchReview.ps1` is removed) |

## What would make a document worth rereading

Its version changed. For the protocol documents:

```
git --git-dir=../rimworld-protocols.git --work-tree=. log -1 --format='%h %ad' --date=short -- <file>
git --git-dir=../rimworld-protocols.git --work-tree=. status --short -- <file>
```

run from the monorepo root; for the other repositories, `git -C <repo> log -1 --format=%h -- <file>`. A file
marked "plus uncommitted edits" is only comparable by its SHA-256.
