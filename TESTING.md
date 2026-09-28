# French Grammar Renew — in-game test scenarios

Nothing in this mod has ever been watched to run in a colony. This file is the list of what has to
be seen there, and what counts as a pass.

A test suite runs beside it, `_tools/Run-Tests.ps1`, and it is not a substitute. What it does cover
is more than a static check: the game's own `LanguageWorker_French` loads outside RimWorld, so the
suite runs each correction sandwiched around the real vanilla rules, exactly as Harmony arranges
them in game. The tested input/output cases are documented in `Tests/RESULTS.md`.

What the suite cannot do is load the mod into the game. Harmony never runs there, no pawn exists,
no window is drawn, and no translation is resolved through the engine's own call chain. A patch
target that resolves in the suite can still fail to patch in game, and a rule that is right on a
test string can still never be reached by the text on screen. That is what these scenarios are for.

Neither file is shipped: both live beside `Mod/`, never inside it, so Steam never receives them.

## Before starting

- RimWorld 1.6 with **Harmony** active, and the game **in French** — Options → Language →
  Français. Two patches target `LanguageWorker_French`; the global pawn-rule patch checks the
  active worker before rewriting anything. Other-language isolation is scenario 12.
- No DLC is required. The word lists cover every expansion, so a run with all of them on is worth
  doing once.
- Development mode on, so silent failures become red text. Mod settings → French Grammar Renew →
  **Verbose log** on for the first pass; it is what turns scenarios 1 and 2 into a readable answer
  instead of a guess.
- The log to read afterwards, and to attach to any report:
  `C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log`

Every line this mod writes begins with `[FrenchGrammarPlus]`, so one search finds all of them.

## The numbers these scenarios rest on

Read out of the game's own files on 2026-09-12, not copied from the mod's prose.

| Claim | Where it was checked | Value |
|---|---|---|
| Aspirated-h prefixes | `Mod/Data/aspirated-h.txt` | 76 |
| Species genders | `Mod/Data/pawnkind-gender.txt` | 115: 25 feminine, 90 masculine |
| Animal pawn kinds the game ships | `Data/*/Defs/ThingDefs_Races/Races_Animal*.xml` | 115 |
| Listed kinds missing from the game | set difference, both directions | 0 |
| French strings with a space before `:` | official `French (Français).tar`, `Keyed/` | 488 |
| French strings with a space before `!` `?` `;` | same | 215 |
| French strings carrying a colour tag | same, whole translation | **0** |

The last row decides how scenario 9 has to be run: **vanilla French text never contains a rich text
tag**, so nothing in the base game can trigger the elision-across-tags correction. It needs a mod
that colours its labels, which is what the mod's own description says it is for.

The two lists agree exactly with the game: all 115 listed species exist, and no animal the game
ships is missing. What cannot be checked outside the game is whether each *gender* is right, since
the French translation carries the label but never its gender. That is editorial, and scenarios 6
and 7 are the only audit of it.

## 1. It loads, and all three patches take

The mod is five corrections hanging off three patch targets. If a target failed to resolve, the
matching correction goes quiet and everything else still works — which is the design, and also the
reason a silent pass here would be misleading.

1. Launch with the mod active, French, verbose log on.
2. Search the log for `[FrenchGrammarPlus]`.

**Pass:** three `patched.` lines, naming `LanguageWorker_French.PostProcessed`,
`LanguageWorker_French.WithDefiniteArticle` and `GrammarUtility.RulesForPawn`.

**Fail:** any `is not present in this version of the game` line, or any `failed to patch`. Both are
errors by design rather than crashes, and both name the correction that stopped working. A
`failed to patch` almost always means Ludeon renamed a parameter: Harmony matches arguments by
name, and this mod assumes `str`, `gender`, `pawnSymbol` and `kind`.

**Also fail:** the game refusing to start, or any red line mentioning `FrenchGrammarPlus` other
than the two above.

## 2. Both word lists load, and a bad line is survivable

1. Same launch, same log.

**Pass:** one line reading `76 aspirated-h words, 115 species genders loaded.`

Any other pair of numbers means a file was edited, or was read in the wrong encoding.

2. Now break it on purpose. Add a junk line to `Mod/Data/pawnkind-gender.txt` — `Muffalo` with no
   `=`, then `Muffalo=x` — and restart.

**Pass:** two warnings, `line ignored, expected defName=f|m` and `unknown gender 'x'`, and the mod
still loads with 114 genders. A missing file must give `data file missing:` and a working mod with
one correction short.

**Fail:** an exception, or the mod failing to load. A word list is data; nothing in it should ever
take the game down.

Undo the edits before going on.

## 3. Aspirated h keeps its article, in running text

This is the shield: a zero-width space is slipped in front of an aspirated word before the vanilla
rules run, and taken out after. Three real vanilla labels exercise it.

1. Spawn a **breach axe** (`MeleeWeapon_BreachAxe`, "hache de brèche"), some **hops**
   (`RawHops`, "houblon") and stand a colonist in **tall grass** (`Plant_TallGrass`,
   "hautes herbes").
2. Read them wherever the game builds a sentence around the label rather than showing it bare:
   a stack's inspect string, a bill, a caravan's contents, a letter about the item.

**Pass:** "de la hache de brèche", "le houblon", "les hautes herbes". The article stays whole.

**Fail:** "d'hache de brèche", "l'houblon". That is the vanilla behaviour this correction exists to
stop, so seeing it means the shield never fired — check that **Aspirated h** is ticked and that
scenario 1 showed `PostProcessed` patched.

**Also fail, and worse:** a stray invisible character left in the text. The guard is removed on the
way out; if a `​` survives into the UI it will show as a gap or a box. Copy a suspect string out
and look at its length.

## 4. Aspirated h in the definite article

`WithDefiniteArticle` builds `l'` itself instead of going through the post-processing rules, so the
shield never sees it. That is a separate patch and a separate test.

1. Tame or spawn a **husky**. The species is in both lists: aspirated h, and masculine.
2. Find it named with a definite article — a letter about it, a tale, a caravan listing.

**Pass:** "le husky". **Fail:** "l'husky".

## 5. Mute h still elides — the test that matters most

A word list that over-matches is worse than no word list: it would break text the game was already
getting right, everywhere, silently. This is the negative test.

1. Look at **medicine** (`herbe médicinale`), a **human** (`humain`), **hyperweave**
   (`hyperfibre`), any colonist backstory mentioning `histoire`, `heure` or `homme`, and, with Anomaly or
Odyssey, any sentence that names a **hallucination** (mute h, and see the defect recorded in `STATUS.md`).

**Pass:** "l'herbe médicinale", "l'humain", "l'hyperfibre", "l'hallucination" — elision as before, exactly as without
the mod.

**Fail:** "la herbe médicinale", "le humain". One of the 76 prefixes is catching a mute-h word.

The list was checked against the ten commonest mute-h words and against every French item label the
game ships that begins with `h`, and none collided. **That check missed `hallucination`** (recorded in
`STATUS.md`): it read item labels, not the text of hediffs, thoughts and letters. This scenario is here for
what that check cannot see: those texts, and a word a DLC or another mod adds.

## 6. A species noun keeps its own gender

The engine gives the species noun the sex of the animal wearing it, so a male megaspider becomes
"le mégaraignée". This is the correction with the largest word list behind it and the smallest
chance of being noticed if it silently stops.

1. Spawn a **male megaspider** (`Megaspider`, listed feminine, French "mégaraignée") and a
   **male cow** (`Cow`, listed feminine, "vache" — the game will call it a bull in English but the
   noun is what matters).
2. Find each in generated text: a letter, a hunting alert, an art description, a tale.

**Pass:** "la mégaraignée" and "la vache" whatever the animal's sex.

**Fail:** "le mégaraignée". Check the **Grammatical gender of species** box, and check the verbose
log, which writes one `gender overridden for '<label>' (<symbol>): <gender>` line each time the
rule fires. No line means the patch never ran on that pawn.

3. The reverse direction matters too: spawn a **female muffalo** (listed masculine) and confirm
   "le muffalo", not "la muffalo".

## 7. The article rules rebuilt, seen in a tale

Scenario 6 watches the label. This one watches the three rules the patch actually rewrites —
`definite`, `indefinite` and `possessive` — through the one vanilla French string that uses them on
an animal.

The string lives in `TaleDef` art descriptions: `[TRAINER_nameDef] se transforme en
[ANIMAL_definite].`

1. Have a colonist train an animal whose gender is overridden — a megaspider is the clearest.
2. Get a sculpture carved about it. Debug actions → generate art with a tale is far faster than
   waiting for one.
3. Read the sculpture's description.

**Pass:** "se transforme en **la** mégaraignée" for a male. **Fail:** "en le mégaraignée".

This is also the scenario that would catch the patch rebuilding the rules from the wrong label: if
the description shows the English label, or the animal's given name where the species belongs, the
rewrite is reading the wrong rule.

## 8. Possessive before a vowel

The engine has no such rule at all, so anything seen here is entirely this mod's doing. There is no
vanilla French keyed string of the form "sa {0}", so the trigger has to be built.

1. Give a colonist an item whose French label starts with a vowel — an **épée** (longsword,
   "épée"), or **armure** — and find text that puts a possessive in front of it. Combat logs and
   art descriptions are the usual source.

**Pass:** "son épée", "son armure". **Fail:** "sa épée".

2. And the case the guard protects: a possessive before an **aspirated** h. "sa hache de brèche"
   must stay as it is, never "son hache".

If no vanilla sentence can be found that puts a possessive before a vowel, say so and mark this
scenario unreachable rather than passed. An untriggered rule is not a working rule.

## 9. Elision across a colour tag

No vanilla French string carries a rich text tag, so this correction cannot be tested with the base
game alone. That is not a defect — the description says mods that colour their labels are the
beneficiaries — but it does mean the test needs one.

1. Add any mod that puts a `<color=...>` in a `label`. Most quality-of-life and faction mods that
   colour item names will do.
2. Find that label after "de", "à" or "la" in generated text.

**Pass:** "d'`<color>`Éclat", "du `<color>`marteau", the elision reaching across the tag, and the
tag still hugging the noun rather than floating off on its own.

**Fail:** "de Éclat", the vanilla result. Or a mangled tag, which would show as raw `<color=...>`
text on screen — that would mean the replacement put the tag back in the wrong place, and is the
one failure here that is uglier than doing nothing.

3. Turn **Elision across colour tags** off and confirm the text returns to "de Éclat". Toggling it
   back is the cheapest proof the correction is the thing doing the work.

## 10. Typography, which is off by default

1. Confirm it is **off** on a fresh install: Mod settings → **Non-breaking spaces** unticked. This
   matters — the narrow no-break space is missing from some fonts and shows as a blank box.
2. Tick it. Look at any of the 488 French strings that put a space before a colon. The alert
   "Ces colons sont affamés :" and the date tooltip "Jours depuis votre arrivée : {0}" are two.

**Pass:** the space before the colon becomes unbreakable, so the colon never begins a line. Visually
the spacing is unchanged, which is the point: the rule absorbs the space already there rather than
adding a second.

**Fail:** a doubled space, or a blank box where the space was. A blank box means the font lacks
U+202F and the setting should go back off — that is the reason it ships off.

3. The two things it must not touch: a **clock time** and a **URL**. Find "12:00" in any schedule
   or letter, and any `http://` in a mod list or credits screen.

**Pass:** both unchanged, no space inserted. The colon rule only fires when a colon ends a clause.

## 11. Settings take effect at once; word lists do not

1. With the game running, untick **Aspirated h** and look again at the breach axe from scenario 3.

**Pass:** the text goes back to the vanilla "d'hache de brèche" without a restart. Every setting is
read on each call, so all five switches behave this way.

2. Now edit `Mod/Data/aspirated-h.txt` — remove `hache` — and look again **without** restarting.

**Pass:** nothing changes. The lists are read once, in the mod's constructor.

3. Restart and look again.

**Pass:** now "d'hache de brèche", and the verbose line reads 75 rather than 76. Put the word back.

This pair is what the settings screen promises in so many words: *edit without recompiling; restart
the game to reload*.

## 12. Inert in every other language

1. Options → Language → English. Restart when asked.

**Pass:** English grammar remains unchanged, and no species-gender override is logged.
Startup patch and lexicon diagnostics may still appear. The worker-specific patches do not run,
and the global pawn-rule patch returns the original rules without rewriting them.

**Fail:** any English text acquiring a French no-break space or a changed article. That would mean
a patch resolved to the base `LanguageWorker` instead of the French one, which is what
`DeclaredMethod` exists to prevent, and it would be affecting every language in the game.

2. Worth one pass in a third language with its own worker — German or Russian — for the same
   reason.

## 13. Added to and removed from a running colony

The description promises no save data and free removal.

1. Load a save without the mod, note a few animal and item names, add the mod, load again.

**Pass:** the save loads with no missing-def warning, and the names read correctly.

2. Remove the mod and load the same save again.

**Pass:** loads clean, text back to vanilla French, and no `Could not find` line naming
`nelim.frenchgrammar` or `FGP.`.

## 14. Settings access, persistence and translated layout

**Preconditions:** a separate test configuration with no saved French Grammar Renew settings;
Harmony and this mod enabled, initially without a button customization mod. Use a new colony
and repeat the persistence check on an existing test save. Keep the current DLL hash with the log.

1. Open Options -> Mod options -> French Grammar Renew in French. Check that the first four
   switches are enabled and typography/verbose logging disabled. Read every label, tooltip and
   scope/data-file note. Repeat in English. No raw keys, fallback French/English, clipping or
   overlap; close and reopen the page without exceptions.
2. Toggle each grammar switch off/on and trigger its corresponding scenario above on newly
   generated text. Toggle verbose logging, trigger a species override, and confirm its diagnostic
   appears only when enabled. Enable it and restart to inspect startup patch/lexicon messages.
3. Set a mixed combination of values, close the dialog, reopen it, restart the game and load
   both test saves. The same global values survive every step; opening a different save does
   not reset them. Return to the defaults before the remaining scenarios.
4. Confirm there is no visible or greyed-out French Grammar Renew MainButton by default.
   Add RIMMSQOL and record its exact version. Reveal `FGP_Settings`, activate it and verify
   that it opens the same native dialog. Change values, close it and reopen from Mod options:
   the values agree and persist after restart. Hide the shortcut again and verify that the
   customization tool retains that choice. Repeat only for other integrations actually claimed.
5. Inspect Player.log throughout: no settings/shortcut exceptions or repeated errors. Record
   language, game/Harmony/customization versions, observed values and screenshots of both routes.

**Expected:** useful controls, shared configuration and native saving work through both routes,
with no required customization dependency for the primary route. A missing runtime environment
or an integration not exercised remains unverified, not a passed test.

## What `tested` requires

Written on 2026-09-28 from `AUDIT.md` (done -> tested). Everything below runs in a game, never by
reading the code, and none of it has been done yet.

- **Every scenario above has run in game and passed**, through a Pickle suite where a running game is
  the only thing that can show it. A green Pickle run says the path was walked, not that the text on
  screen is right: read `exitReason` before the counts, compare the scenarios played with the
  features discovered, and open every `@review` capture.
- **No scenario is left `@wip`.** One that was set aside is repaired and replayed, or deleted with
  its reason. A `@wip` scenario is waiting, not passed.
- **Every conditional scenario has run.** Each `@requires:<packageId>` had its own pass, with the map
  that mounts that mod, and its report was read (`setName`, the suite and scenario names checked
  before quoting it: the report folder is shared by the whole machine). A scenario skipped for lack of
  its condition is not passed.
- **No manual test is left to tick.** Each of the fourteen scenarios is either automated and green, or
  listed below as not applicable with its reason. The `@review` captures are still read by a person,
  but that is reading an image a scenario has already proved to be in the wanted state, not one more
  manual test.
- Logs read, both languages, settings persistence and the MainButton checked, new colony and existing
  save covered where relevant, and a regression pass after any correction.

## Passes

A suite is played in several passes, one request each, and this file has to say how many and what
each covers. This is the plan for the suite that does not exist yet (none is written); the passes
follow `PickleTools/Authoring/README.md`, section 3, and are to be confirmed when the suite is.

| Pass | Mod set | Language | Covers |
|---|---|---|---|
| 1. Minimal | Core, the DLCs, Harmony, RimLogging, Pickle and this mod, no optional mod | French | scenarios 1 to 8, 10, 11 and 14 (routes, defaults, layout) |
| 2. English | the same set | English | scenario 12 (inert outside French) and the English layout of 14 |
| 3. Third language | the same set | German | scenario 12, step 2: another language with its own worker |
| 4. RIMMSQOL | pass 1 plus RIMMSQOL (Workshop 1084452457) | French | scenario 14, step 4: reveal, open, hide, and that the choice persists |
| 5. Colour labels | pass 1 plus one mod that puts `<color>` in a label | French | scenario 9, the only one that needs a rich text tag; **the mod is not chosen yet** |
| 6. Restart | pass 1, one launch that writes then one that reads | French | scenario 14, step 3, and the word lists reloading in scenario 11 |

**No pass for an incompatibility:** none is declared in `About.xml`. **No pass without a DLC:** the mod
reads no DLC def, so a missing DLC only leaves some word list entries unused, which nothing tests.
b606's old mod is not declared incompatible either; see `BACKLOG.md`.

## Where each scenario stands

"Offline" means `_tools/Run-Tests.ps1`, which runs the mod's own code around the game's own French
rules without starting the game. "In game" is what only a running colony can show. The last column is
a proposal, to be settled when the suite is written; a step that does not exist in the catalogues
(`PickleTools/docs/steps.md`, and Pickle's own on GitHub, not read here) has to be checked before any
C# is written for it.

| # | Offline today | Only a game can show | Proposed form |
|---|---|---|---|
| 1 | The three targets exist with the parameter names Harmony matches by (4 tests) | That Harmony actually patches them, and the log lines | Pickle: a load audit of the mod and a check for the three `patched.` lines |
| 2 | The lists parse and agree with the game's defs (6 tests) | `Lexicon.Load` itself, which needs the game's `ModContentPack`; the survival of a junk line | Pickle for the count line; the junk-line step edits a shipped file, so it stays manual or is dropped with its reason |
| 3, 4, 5, 8 | Each correction, around the real vanilla rules, on strings (8 tests) | That the engine's own sentences reach the patch, on real labels | Pickle, if a step can trigger a generated sentence and read it back; otherwise `@review` |
| 6, 7 | Species gender on/off, other languages, unlisted species (1 test) | The article on a real animal, and the tale text | Same difficulty as 3 to 8; the tale needs a sculpture with a tale |
| 9 | Elision across a tag, on strings | A real label that carries a tag | Pickle pass 5, `@requires` the chosen mod |
| 10 | Typography off by default, colon and clock rules | That the font draws the no-break spaces | `@review` capture in French, read by a person |
| 11 | Every switch turns off its own correction (1 test) | The same on newly generated text, and the lists on restart | Pickle, plus the restart pass |
| 12 | English, German and null workers leave the rules alone | The same in a running English or German game | Pickle passes 2 and 3, asserting that no gender override is logged |
| 13 | The mod stores nothing in a save: only `ModSettings` uses `Scribe`, no game component | Nothing: how the game loads a save with or without a mod is the game's, not the mod's | **Not applicable**, per "On ne teste pas le jeu" in `AUDIT.md`; the unresolved-def check of the load audit still covers the log line |
| 14 | Defaults, 64 combinations round-trip, the shortcut Def and worker contract (5 tests) | Both routes, persistence across a restart, the shortcut through RIMMSQOL, layout in both languages | Pickle with the RIMMSQOL, keyed-click and hover steps of `PickleTools`, `@review` for layout |

## What to keep after a test, and what to delete

Rule of the collection's `AGENTS.md`: a report about a superseded build proves nothing about the
current one, and reports can reach gigabytes on a full disk. `PickleTools/TESTING.md` has the long form.

**Keep, on disk, per pass** (in `Tests/Pickle/Evidence/`, ignored by git): `summary.json` and
`summary.md`, `junit.xml`, `messages.ndjson`, `Player.log`, `evidence-complete.txt` or `no-report.txt`,
and the `@review` captures the pass exists to produce, **minified to JPEG**. Ask for the folder with
`-EvidenceDir` so the report is copied out of the shared, rolling `pickle-reports` before the next run
overwrites it. Never copy that folder whole.

**Keep in git, one text line per run** in `docs/runs/history.md`: date, pass, revision, `exitReason`,
scenarios played of discovered, verdict, and what was opened.

**Delete**: a `screenshots/` folder copied whole, `report.html`, the report of a failed or
infrastructure-error attempt once its line is written, a report superseded by a newer one for the
same scenario and revision (unless the older is the only proof of a check the newer did not repeat: a
language, an optional-mod pass), and any report of a superseded build once the pass is repeated on the
current one. **Never delete a report that `STATUS.md` still points to**: repoint the field first.
List what goes and what stays before deleting. A plain recursive delete stalls on capture names past
MAX_PATH: mirror an empty folder over the target with robocopy first, then delete the empty shell.
## What none of this can prove

- **That every one of the 115 genders is the right one.** The scenarios above check the machinery
  on perhaps a dozen species. The other hundred are a reading of the official translation, and
  only a French speaker looking at generated text over a long game will find a wrong one.
- **That the 76 prefixes are complete.** Scenario 5 catches over-matching, which is the dangerous
  direction. Under-matching — a missing aspirated word — shows up as vanilla behaviour and looks
  like nothing at all.
- **That a future version still resolves.** Scenario 1 is the whole of that check, and it has to be
  re-run on every game update.
