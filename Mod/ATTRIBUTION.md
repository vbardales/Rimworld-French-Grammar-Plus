# Attribution

No third-party file is copied into this mod, and no third-party assembly is redistributed with
it. What follows is what was studied, and what this mod deliberately does *not* do.

## LanguageWorker_French Mod, by b606, after Adirelle and Elevator89

https://github.com/b606/RimWorld-LanguageWorker_French —
https://steamcommunity.com/sharedfiles/filedetails/?id=2081845369

That mod is where this one comes from, and most of its work is now in the game itself.

Between 2019 and 2020, Adirelle wrote the first French elision regexes and b606 built them into
a Harmony mod, itself adapted from Elevator89's `LanguageWorker_Russian` project. Ludeon
subsequently adopted those rules into vanilla `LanguageWorker_French`. Checked against
`Assembly-CSharp.dll` of build 1.6.4871, the following are present in the shipping game,
character for character:

    \b([cdjlmnst]|qu|quoiqu|lorsqu)e ([a...h])     elision
    \b(l)a ([a...h])                               elision
    \b(s)i (ils?)\b                                s'il / s'ils
    \b(d)e l(es?)\b                                du / des
    \bà les?\b                                     au / aux
    bijou, bleu, émeu, lieu, plateau, travail...   plural exceptions

**This mod does not reimplement any of them.** It covers only what the vanilla versions cannot
reach, and its README states which gap each of its own rules addresses. Where b606's approach was
kept, it is named as his in the code comments: the zero-width guard that stops the vanilla elision
rules from touching an aspirated word is his idea.

Two things were deliberately not carried over. His `ToTitleCase` reads the call stack with
`new StackTrace()` and hardcoded frame indices, which is both expensive and silently version
dependent; that feature is dropped rather than ported. His word lists are not reused either:
**his repository carries no licence file**, only an `AssemblyCopyright` notice, so nothing of his
is copied. This mod's aspirated-h list was rebuilt from standard French — the set of aspirated-h
words is a fact of the language, while the *selection* of them limited to a given game's
vocabulary is editorial work that remains his.

If b606 or Adirelle would rather this mod did not exist in its present form, say so and it
changes.

## Ludeon Studios

`Assembly-CSharp.dll` was read — with `System.Reflection.MetadataLoadContext` and Mono.Cecil, for
signatures and IL — to establish which corrections vanilla already performs and where the
remaining gaps are. **No decompiled game code is reproduced in this repository**, and no game
asset is redistributed. The reference assemblies used to compile come from the
`Krafs.Rimworld.Ref` NuGet package and are not shipped.

## Harmony, by Andreas Pardeike

https://github.com/pardeike/Harmony — MIT.

Referenced for compilation only, `ExcludeAssets=runtime`. At runtime it is provided by the Harmony
mod, declared as a dependency in `About.xml`, so no copy of it ships here.

## AI generation

This mod's code and documentation were written with Claude Code (Anthropic) under human direction
and review. Stated openly: designing with these tools is my job.
