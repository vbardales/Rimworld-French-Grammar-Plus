# Protocol documents read for this mod

A log of what was read, at which version, and whether it was of use, so that a later session rereads a
document only when it has moved. "Version" is the last commit touching the file **in the repository that
holds it**. For the protocol documents that is `vbardales/Rimworld-protocols` (git dir
`../rimworld-protocols.git`, work tree the monorepo root), **not the monorepo**: `git log -1 -- AUDIT.md`
run from the monorepo answers with the commit that removed the file, a plausible hash for the opposite of
what is wanted (`Rimworld-Ticket-Dispatcher/docs/WELCOME.md`, section 5). The SHA-256 is given for the
files that were modified and not yet committed, since a commit hash cannot name them.

Read on 2026-09-28, by the session of this mod (`local_f7c8f179-b0fc-432a-bd6f-23aa8e0fddd0`).

## Protocols repository (`vbardales/Rimworld-protocols`)

| Document | Version | Read | Useful for this mod |
| --- | --- | --- | --- |
| `AGENTS.md` | 3a1d2cb (2026-09-24) | in full | yes: gate order (settings, translations, `preTest`), evidence retention, CI publish rules |
| `AUDIT.md` | c5ca0c0 (2026-09-26) **plus uncommitted edits**, sha256 `e85f12850`, 246 lines | in full | yes: it is the workflow. The chain, each transition's criteria, the `done -> tested` rules, the session title. Its Pickle and machine sections (lines 5-23, 150-202) only matter once a run is submitted |
| `MOD_SETTINGS.md` | b83933b (2026-09-23) | in full | yes: this mod has settings and a hidden shortcut. It says `partial` while runtime tests remain, `AUDIT.md` (options -> l10n) says they belong to `tested`; the audit prevails |
| `TRANSLATIONS.md` | f5c2d9d (2026-09-25) | in full | yes: `localization`, `translation_en`, `translation_fr`. The plural rule led to a verified gap noted in `BACKLOG.md` |
| `PUBLISHING.md` | 95c6dfd (2026-09-28) | in full | partly: the origin-repository route, the `(unofficial)` suffix and notice, the description order, the packageId rule (no `renew`, 2026-09-27). Not useful now: git sessions and `--amend`, topics and social preview, CI details |
| `STYLE_RIMWORLD.md` | 7311308 (2026-09-25) **plus uncommitted edits**, sha256 `2c6db3239` | in full | partly: the Preview overlay, the palette file and the ModIcon *control* section. Not useful: the image prompt blocks, the count rule (nothing is generated here) |
| `WORKSHOP_COMMENTS.md` | dea856b (2026-09-28) **plus uncommitted edits**, sha256 `6950daa56` | in full | partly, and only at `prepublished`: rows for Harmony, Pickle, RimLogging and RIMMSQOL exist and need this mod added to `Covers`; **there is no row for b606's page (2081845369)**. The other rows and the incident log: not useful |
| `scripts/SEARCHING.md` | 372c447 (2026-09-23) **plus uncommitted edits**, sha256 `013075b06` | in full | not for the audit. Useful for one backlog item (who else patches `LanguageWorker_French`) and for its rule against unbounded recursive walks |

## Other repositories

| Document | Version | Read | Useful for this mod |
| --- | --- | --- | --- |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | 3c03f51 (2026-09-26) | in full | partly: first publication of a mod, versions and change notes. Not useful: Steam credentials, semantic-release |
| `PickleTools/README.md` | c771bef (2026-09-25) | in full | partly: the tool table. This mod would use `RimmsqolSteps`, `LoadAudit`, `KeyedClick`, `HoverSteps`, `InterfaceScale`, `ScreenshotMode` |
| `PickleTools/Headless/README.md` | ed4e73a (2026-09-26) | in full | partly: filters, passes, `-EvidenceDir`, what a report keeps. Not needed until a run is submitted: the launcher's exit codes, machine traps |
| `PickleTools/docs/steps.md` | 96eda0f (2026-09-28) | in full | partly: only the sections of the six tools above. The other tools' steps (research, colonists, sound, new colony, VEF, textures, coats) are of no use to this mod |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | 77ca9d7 (2026-09-27) | in full | yes: the reading list (section 5), the protocols git-dir trap, no Explorer artefact in `Mod/`. Registering with the dispatcher is not needed until a run is submitted |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | d07b2b8 (2026-09-26) | in full | not yet: no run is submitted. It is the reference for the Pickle suite's first request |
| `PickleTools/Authoring/README.md` | 8d3ca6d (2026-09-26) | lines 1-150 and 248-321; **151-247 unread** (waiting and timeouts, adding C#) | yes: what needs a running game, the pass matrix, evidence. Not on the list given for this session: read because `AUDIT.md` points to it |
| `PickleTools/TESTING.md` | 650adce (2026-09-25) | the section "What to keep after a test" only | yes: it is the rule copied into this mod's `TESTING.md` |

## This mod's own documents

| Document | How far |
| --- | --- |
| `STATUS.md` | in full, before it was rewritten. The previous body is archived in `docs/audits/2026-09-13-status-sections.md` |
| `README.md`, `CHANGELOG.md`, `TESTING.md`, `Tests/RESULTS.md`, `Tests/artifact-sha256.json`, `Mod/About/About.xml` | in full |
| `ATTRIBUTION.md`, `LICENSE` | `ATTRIBUTION.md` in full (unchanged since 2026-09-04 until this session added one section); `LICENSE` compared byte for byte with its `Mod/` copy and its header read |
| `BACKLOG.md`, `docs/runs/history.md`, this file | created in this session |
| `PUBLICATION.md`, `NOTES.md`, `BUGS.md`, `Tests/Pickle/` | **do not exist.** `PUBLICATION.md` is due at `prepublished`; nothing has been written for the other three because nothing belongs in them yet |

## What would make a document worth rereading

Its version changed. For the protocol documents:

```
git --git-dir=../rimworld-protocols.git --work-tree=. log -1 --format='%h %ad' --date=short -- <file>
git --git-dir=../rimworld-protocols.git --work-tree=. status --short -- <file>
```

run from the monorepo root; for the other repositories, `git -C <repo> log -1 --format=%h -- <file>`. A file
marked "plus uncommitted edits" is only comparable by its SHA-256.
