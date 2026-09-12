---
mod:          French Grammar Plus
packageId:    nelim.frenchgrammarplus
repo:         Rimworld-French-Grammar-Plus
visibility:   public
detached:     yes
stage:        preTest
licence:      silent
licence_at:   b606's repository carries no LICENSE, only an AssemblyCopyright, and it has been dead since November 2020. No file, no line and no word list of his is copied. One idea is his and is credited in ATTRIBUTION.md: the zero-width guard that keeps the vanilla elision rules off an aspirated word. This mod's own LICENSE is a bare MIT.
dependencies: declared
showcase:     complete
tested_on:
workshop:
remaining:
  - defect: the ModIcon is off style. The mascot is right, but she carries readable text -
    "Plus" in a speech bubble, "Grammaire" on the book - and a tricolour flag. The test is at
    32 px, where all three become a smear instead of a landmark. To regenerate.
  - unverified: never seen running. The thirteen scenarios of TESTING.md, none played. Start with
    the first: until the log shows all three patches took, the other twelve prove nothing.
  - unverified: scenario 9, elision across a colour tag, cannot be run with the base game alone -
    no vanilla French string carries a rich text tag, so it needs a mod that colours its labels.
  - feature: no out-of-game harness. The eight checks run on 2026-09-11 live in no committed file,
    and the two word lists are verified against the game's defs by hand rather than by a test.
  - unverified: never uploaded to the Workshop, so the showcase has never been seen in place.
session:      local_f7c8f179-b0fc-432a-bd6f-23aa8e0fddd0
updated:      2026-09-12, test scenarios written
---

# French Grammar Plus — status

One card per mod, first read by a sweep across the whole repository rather than by asking each
thread in turn. It lives at the root, never inside `Mod/`, so Steam never receives it. This one is
no longer swept: the mod's own session holds it and keeps it current.

## What the sweep could not read, and what the answers are

- **`stage`** — `preTest`. The code is finished and the paperwork is complete, but nothing is
  written to test against: no scenario document, no out-of-game harness. That is what separates
  `preTest` from `done` elsewhere in the repository. Crystal Ball and Burn Barrel are `done` with
  their scenarios written and unplayed; For the Occasion is `preTest` for the same reason as this
  mod.
- **`tested_on`** — empty. The mod has never been run.
- **`dependencies`** — `declared`. Harmony is the only one, named in `modDependencies`, and it is
  referenced for compilation alone with `ExcludeAssets=runtime`, so no copy ships. The two
  `loadAfter` entries are Harmony again and vanilla, so neither hides an undeclared dependency.
- **`remaining`** — above. The icon is the only defect; the rest is what has not been seen. The
  scenario document the sweep found missing now exists as `TESTING.md`, so what is left is playing
  it, and an out-of-game harness the mod has never had.

## Two fields the sweep filled in wrong

- **`licence` was `original`.** It is `silent`. The vocabulary below reserves `original` for a mod
  owing nothing to anyone, not even an idea traceable to one mod, and this one owes the zero-width
  guard to b606 and says so in `ATTRIBUTION.md`. Nothing of his is copied, his repository has no
  licence and his mod is dead: that is `silent` exactly.
- **`licence_at` claimed nothing is reused.** An idea is, and it is credited. Rewritten above.

`showcase: complete` stands, and is not contradicted by the icon defect: the field records which
art exists, and both files do. What is wrong with one of them belongs in `remaining`.

## Vocabularies

`stage`: `port`, `showcase`, `preTest`, `done`, `tested`, `published`.

`licence`: `open` an explicit licence, `silent` no licence and a dead source, `alive` no licence
but a living source, `forbidden` a written refusal, `original` owing nothing to anyone — not a
name, not an idea traceable to one mod, not a value derived from its assets.

`showcase`: `none`, `icon`, `preview`, `complete` — which of the two images exist, not whether
they are any good.

`dependencies`: `declared` when every mod this one needs is named in the About's
`modDependencies`, `to check` when a non-vanilla `loadAfter` suggests a dependency that is not
declared, `none` when the mod needs nothing. An undeclared dependency is not cosmetic: on
2026-09-11 Reequilibrage animaux took 47 vanilla animals down with it, Muffalo included, because
the class it injects belongs to a mod that was not declared and not loaded.

`remaining`: `feature` for something missing from a first release, `defect` for a known fault left
unfixed, `unverified` for what could not be checked.
