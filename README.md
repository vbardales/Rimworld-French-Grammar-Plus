# French Grammar Plus

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
  wholesale, which fights any other language mod. Here every patch hangs off
  `LanguageWorker_French` itself, so it is inert in any other language and needs no guard.
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
run yet. Before publishing, check in-game that each of the five corrections fires, with
**Verbose log** on.

## Build

    dotnet build Source/FrenchGrammarPlus.csproj

Output goes to `Mod/Assemblies/`. `Mod/` is the folder to drop in RimWorld's `Mods/`.

## Credits

Adirelle and b606, for the rules Ludeon adopted and for the zero-width guard this mod still uses.
Their repository carries no licence, so nothing of theirs is copied here: see `ATTRIBUTION.md`.
Andreas Pardeike, for Harmony.
