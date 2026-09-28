# Backlog

This mod's own list of open questions and ideas, not the monorepo's `BACKLOG.md`. Nothing here is
part of a gate unless `STATUS.md` says so. Each line says whether it was verified or only heard.

## Waiting for the owner

- **Done on 2026-09-28, at the owner's word: repository and folder renamed to Renew.** The repository is
  `Rimworld-French-Grammar-Renew` (the old address redirects), the folder `FrenchGrammarRenew`, the name
  `French Grammar Renew (unofficial)` and the packageId `nelim.frenchgrammar`. The code keeps its namespace and
  assembly name `FrenchGrammarPlus`; nothing requires renaming them. The Steam item still carries the old id
  and name until the next upload, and the settings file the game writes is named after the folder, so it starts
  again under the new name.
- **Decided on 2026-09-28: the ModIcon stays.** Its speech bubble reads "plus" and the mod is called Renew; the owner
  answered that the "Plus" suits her. Nothing to do.
- **Choose the mod that colours a label**, for the pass that plays scenario 9 (`TESTING.md`, "Passes").
- **Done on 2026-09-28, at the owner's "case by case": the `hall` prefix is dropped.** It caught `hallucination(s)`,
  `hallucinogene` and `hallux`, which take a mute h (the mod wrote "la hallucination" where vanilla was right).
  The list matches by prefix with no exception, so `hall` could not tell them from the aspirated `hall`, and the
  Académie française marks `hall` aspirated. `halle` stays and covers `halle` and `hallebarde`. The loanword `hall`
  itself is no longer corrected: it occurs a handful of times in the game's French text. **Add an aspirated word of
  that family one by one, only when a real sentence needs it** (`hallali`, `hallier`, `hallage` are aspirated too, and
  were not added for want of a text that uses them). `halloumi` stays unconfirmed. Both negative tests of the suite
  now know `hallucination`, `hallucinogene` and `hallux`, and were seen to fail with the prefix put back.

## Asked by another session

From the Flavor Text Extended - Français session, 2026-09-28, on the owner's request. Heard, not done.

- **Done on 2026-09-28: `hachis` and `harissa` added** to `Mod/Data/aspirated-h.txt`, on the owner's decision
  relayed by that session. Both are confirmed aspirated by the Académie française (9th edition, entries
  "hachis" and "harissa": "h initial est aspiré"). The list was 78 entries then, 77 after `hall` went. **Not added**, and that session was
  told: `houmous` and `hummus` (Wiktionnaire gives "h aspiré ou h muet", Larousse marks nothing, so usage is
  shared); `hot-dog` (only the Wiktionnaire says aspirated; Larousse does not mark it and no Académie entry
  was found); `halloumi` (no source found; it is caught today only by the `hall` prefix, so it needs its own
  exact entry once confirmed, and before `hall` goes). Four of their words (`haricot`, `houblon`, `husky`,
  `héron`) were already listed.- Confirm that a sentence built by `CompFlavor.CompileFlavorLabels` and `CompileFlavorDescriptions`,
  which goes through `worker.PostProcessed(text)`, is corrected by the mod. Offline the mod's rules
  already run around the real `PostProcessed`, so "un plat de husky", "des haricots" and "de houblon"
  can be tried through that harness; the patch installation itself is scenario 1.
- Give that session the final packageId and name, and say when the mod is public, so that it can add a
  soft `loadAfter` and skip its own regex when this mod is active.

## Ideas, not started

- **`Pluralize` ignores its count in French.** Verified on 2026-09-28 against the game's own
  `LanguageWorker_French` (1.6.4871), through the test harness: `Pluralize("recette", Female, 1)`
  returns `recettes`, and so do 0, 2 and 5. `TRANSLATIONS.md` says the same. Whether a sentence the
  game builds actually reaches it with a count of 1 is not established. If it does, it is a sixth
  correction for this mod and a new feature, so a decision before any code.
- **Who else patches `LanguageWorker_French`?** Not searched. `scripts/Search-Workshop.sh` reads the
  Workshop corpus for `LanguageWorker_French` and `PostProcessed`; the answer decides whether an
  `incompatibleWith` or a note is due. b606's mod (`b606.LanguageWorkerFrench.Mod`) replaces the
  worker class wholesale and declares 1.0 to 1.2 only, so what happens beside it in 1.6 is unknown.
- **`Art/Preview-source.png` is byte-identical to `Art/Preview.png`** (1.5 MB each, both tracked).
  `STYLE_RIMWORLD.md` keeps the source under `Art/Preview.png`, so one of the two is redundant.
- **`Mod/desktop.ini` exists on disk**, ignored by git, created on 2026-09-27 for the folder icon.
  The CI ships tracked files only, but an upload from the game sends `Mod/` as it stands: remove that
  file first. The 0.1.0 upload predates it.
