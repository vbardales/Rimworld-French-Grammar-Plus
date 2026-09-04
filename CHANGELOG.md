# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it
in game.

## [1.0.0] — unreleased

On release: create the `v1.0.0` tag and the matching GitHub release.

First version. RimWorld 1.6, Harmony required. **Not yet tested in game.**

### Added

- Elision across rich text tags. The vanilla French rules stop at a markup tag, leaving
  `de <color=#D09B61FF>Éclat</color>` as "de Éclat"; the same four rules are applied again here,
  this time reaching across the tag, for `de`/`la` elision and for the `du`/`des`/`au`/`aux`
  contractions. Mods that colour their labels are the main beneficiaries.
- Aspirated h. The vanilla vowel set includes `h` and carries no exception list, so the game
  writes "l'haricot" and "d'hache". A zero-width guard is inserted before an aspirated word ahead
  of the vanilla rules and removed after them, so the article survives untouched.
- Possessive before a vowel: "sa épée" becomes "son épée". The engine has no such rule at all.
- Grammatical gender of species nouns, independent of the animal's sex, so "la mégaraignée" stays
  feminine for a male. The three affected grammar rules are rebuilt from the label the engine
  itself produced, rather than by mutating the shared `PawnKindDef`.
- French typography — no-break spaces before `:` `;` `!` `?` — off by default, since not every
  font carries the narrow no-break space.
- Two editable word lists in `Mod/Data/`, read as UTF-8, so a translator can extend them without
  a compiler.
- Mod settings with one switch per correction, and a verbose log for bug reports.

### Deliberately absent

- Every rule already present in vanilla `LanguageWorker_French`. See `ATTRIBUTION.md`.
- `ToTitleCase` call-stack inspection.
