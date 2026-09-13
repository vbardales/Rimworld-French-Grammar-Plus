# French Grammar Plus (unofficial)

UNOFFICIAL. This mod is published without the original author's explicit consent. If the original author contacts me to request its removal, I undertake to take it down promptly.

A RimWorld 1.6 mod that finishes the French grammar the engine already does most of.

## Why it is small

RimWorld 1.6 ships a `LanguageWorker_French` that already contains, verbatim, the elision,
contraction and plural rules written by Adirelle and b606 for the old
[LanguageWorker_French mod](https://github.com/b606/RimWorld-LanguageWorker_French) (last updated
November 2020, tagged 1.0-1.2). Checked against `Assembly-CSharp.dll` of build 1.6.4871, the
following are vanilla and are deliberately **not** reimplemented here:

    \b([cdjlmnst]|qu|quoiqu|lorsqu)e ([aàâä...h])     elision
    \b(l)a ([aàâä...h])                               elision
    \b(s)i (ils?)\b                                   s'il / s'ils
    \b(d)e l(es?)\b                                   du / des
    \bà les?\b                                        au / aux
    bijou, bleu, émeu, lieu, plateau, travail...      plural exceptions

## What is left, and what this mod does

| Gap in 1.6 | Where |
|---|---|
| The vanilla regexes have no group for a rich text tag, so `de <color=...>Éclat</color>` stays `de Éclat` | `FrenchGrammar.ElisionE/ElisionLa/DeLe/ALe` |
| The vanilla vowel set **includes `h`** and there is no exception list, so it writes `l'haricot` | `FrenchGrammar.Shield` + `Data/aspirated-h.txt` |
| No possessive rule at all: `sa épée` | `FrenchGrammar.PossessiveVowel` |
| The gender of a species noun follows the animal's sex: `le megaspider` | `RulesForPawnPatch` + `Data/pawnkind-gender.txt` |
| No French typography | `FrenchGrammar.Apply`, off by default |

Anything expressible in translation XML is out of scope on purpose and belongs in
[Ludeon/RimWorld-fr](https://github.com/Ludeon/RimWorld-fr): wording fixes, and the masculine and
feminine word lists that `LanguageDatabase.ResolveGender` reads from `Strings/`.

## Design notes

- **No language worker substitution.** The old mod replaced `LoadedLanguage.info.languageWorkerClass`
  wholesale, which fights any other language mod. Elision patches target `LanguageWorker_French`;
  the global pawn-rule patch checks the active worker and leaves other languages untouched.
- **No `StackTrace`.** The old mod called `new StackTrace()` inside `ToTitleCase` and read
  `GetFrame(3/4/5)` to guess its caller. That is expensive on a method the game calls constantly,
  and silently wrong the first time the JIT inlines differently. That whole feature is dropped.
- **Methods resolved by shape.** `RulesForPawn` is found as "the one taking a `PawnKindDef`",
  not by an exact fifteen-type signature that a DLC will invalidate.
- **Every patch may fail alone.** `Patcher.TryPatch` logs one red line naming the feature that
  went quiet and keeps the rest loading.
- **Source is pure ASCII.** Accented characters are `\u` escapes, so no compiler codepage can
  mangle them. The word lists are UTF-8 data files, read as UTF-8 explicitly.

## Known fragile points

Harmony matches patch arguments to the original's parameters **by name**. Three names are assumed:
`str` in `PostProcessed`, `gender` in `WithDefiniteArticle`, `pawnSymbol` and `kind` in
`RulesForPawn`. If Ludeon renames one, the log says so at startup and that correction stops; it
never breaks the game.

## Not yet verified in game

Everything above is read off the 1.6 assembly and off the old mod's source. None of it has been
run yet. `TESTING.md` is the list of what has to be watched in a running colony and what counts as
a pass: fourteen scenarios, starting with the log line that says all three patches took, and with
**Verbose log** on throughout the first pass.

One of them cannot be run with the base game alone. No vanilla French string carries a rich text
tag, so the elision-across-tags correction needs a mod that colours its labels before it has
anything to act on.

## Build

    dotnet build Source/FrenchGrammarPlus.csproj

Output goes to `Mod/Assemblies/`. `Mod/` is the folder to drop in RimWorld's `Mods/`.

## Settings

Open **Options -> Mod options -> French Grammar Plus**. All six checkboxes are global:
the four grammar corrections start enabled; typography and verbose logging start disabled.
Grammar switches affect newly generated text immediately. Startup diagnostics and edited word
lists require a restart. Settings are saved by the native dialog when it closes.

An optional **French Grammar Plus** MainButton opens the same native settings dialog. It is
hidden by default, neither visible nor greyed out. RIMMSQOL or a compatible customization tool
can reveal its `FGP_Settings` definition; no such tool is required for the primary access.
The Def and native visibility inheritance are checked outside the game; interactive RIMMSQOL compatibility
has not yet been verified.

## Tests

    powershell -NoProfile -File _tools/Run-Tests.ps1

Thirty-three tests, a few seconds, and RimWorld is never started. The game's own
`LanguageWorker_French` loads outside it, so the grammar tests run each correction sandwiched
around the real vanilla rules rather than around a description of them: every case asserts both
that vanilla alone still produces the fault and that this mod's output is right. The word lists are
checked against the animal defs the game actually ships, in both directions.

The additional settings regressions cover all 64 checkbox combinations with real Scribe
serialization, missing stored values, species-rule isolation in English/German, verbose
output and the shortcut definition/worker contract. Unity-backed pronoun translation and logging endpoints
are supplied by test callbacks; this is not proof of a running game or Harmony installation.
See `Tests/RESULTS.md` for the tested artifact and remaining in-game checks.

## Credits

Adirelle and b606, for the rules Ludeon adopted and for the zero-width guard this mod still uses.
Their repository carries no licence, so nothing of theirs is copied here: see `ATTRIBUTION.md`.
Andreas Pardeike, for Harmony.
