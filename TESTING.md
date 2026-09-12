# French Grammar Plus — in-game test scenarios

Nothing in this mod has ever been watched to run in a colony. This file is the list of what has to
be seen there, and what counts as a pass.

A test suite runs beside it, `_tools/Run-Tests.ps1`, and it is not a substitute. What it does cover
is more than a static check: the game's own `LanguageWorker_French` loads outside RimWorld, so the
suite runs each correction sandwiched around the real vanilla rules, exactly as Harmony arranges
them in game. Every grammar rule in this mod is therefore already known to produce the right string.

What the suite cannot do is load the mod into the game. Harmony never runs there, no pawn exists,
no window is drawn, and no translation is resolved through the engine's own call chain. A patch
target that resolves in the suite can still fail to patch in game, and a rule that is right on a
test string can still never be reached by the text on screen. That is what these scenarios are for.

Neither file is shipped: both live beside `Mod/`, never inside it, so Steam never receives them.

## Before starting

- RimWorld 1.6 with **Harmony** active, and the game **in French** — Options → Language →
  Français. Every patch in this mod hangs off `LanguageWorker_French`; in any other language the
  mod is inert by construction, which is scenario 12.
- No DLC is required. The word lists cover every expansion, so a run with all of them on is worth
  doing once.
- Development mode on, so silent failures become red text. Mod settings → French Grammar Plus →
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
   (`hyperfibre`), and any colonist backstory mentioning `histoire`, `heure` or `homme`.

**Pass:** "l'herbe médicinale", "l'humain", "l'hyperfibre" — elision as before, exactly as without
the mod.

**Fail:** "la herbe médicinale", "le humain". One of the 76 prefixes is catching a mute-h word.

The list was checked against the ten commonest mute-h words and against every French item label the
game ships that begins with `h`, and none collide. This scenario is here because that check cannot
see a word a DLC or another mod adds.

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

**Pass:** nothing changes anywhere, and no `[FrenchGrammarPlus]` line appears beyond the three
startup ones. The patches are still installed — they hang off `LanguageWorker_French`, which is
simply never called.

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
`nelim.frenchgrammarplus` or `FGP.`.

## What none of this can prove

- **That every one of the 115 genders is the right one.** The scenarios above check the machinery
  on perhaps a dozen species. The other hundred are a reading of the official translation, and
  only a French speaker looking at generated text over a long game will find a wrong one.
- **That the 76 prefixes are complete.** Scenario 5 catches over-matching, which is the dangerous
  direction. Under-matching — a missing aspirated word — shows up as vanilla behaviour and looks
  like nothing at all.
- **That a future version still resolves.** Scenario 1 is the whole of that check, and it has to be
  re-run on every game update.
