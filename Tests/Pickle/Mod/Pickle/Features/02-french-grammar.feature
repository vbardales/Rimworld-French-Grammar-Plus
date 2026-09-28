# TESTING.md, scenarios 3, 4, 5, 6, 7, 8, 9, 10 and 11. Plays in the FRENCH pass only: the English pass is aimed
# at 03-english-isolation.feature, and this file is left out of it by name (see README.md).
#
# The offline suite runs the mod's rules around the game's own LanguageWorker_French and proves them on strings.
# These steps call the same entry points the engine calls, PostProcessed and WithDefiniteArticle, on the worker
# a running French game is actually using, once every patch is installed: the step from "the rule is right" to
# "the patched game applies it". A sentence the engine builds and displays is not read back here; that is the
# @review captures of 04 and the human reading them.
#
# The rich text tag needs no other mod for its RULE: the string carries the tag. A real label that carries one
# is a different question, and it is deliberately not asked in this suite (README.md).
Feature: the French corrections apply in a running French game

  Background:
    Given French Grammar Renew: the settings are at their documented defaults

  Scenario Outline: an aspirated h keeps its article, where the engine alone would elide it
    Then French Grammar Renew: the language worker turns "<input>" into "<output>"
    And French Grammar Renew: the language worker leaves no zero-width space in "<input>"

    Examples:
      | input      | output     |
      | de husky   | de husky   |
      | de haricot | de haricot |
      | le haricot | le haricot |
      | de houblon | de houblon |
      | de hachis  | de hachis  |
      | de harissa | de harissa |
      | la hache   | la hache   |

  # The dangerous direction: a word list that over-matches breaks text the game already got right.
  Scenario Outline: a mute h still elides, exactly as without the mod
    Then French Grammar Renew: the language worker turns "<input>" into "<output>"

    Examples:
      | input            | output          |
      | de herbe         | d'herbe         |
      | de homme         | d'homme         |
      | le humain        | l'humain        |
      | de hallucination | d'hallucination |
      | de hallux        | d'hallux        |

  Scenario Outline: the possessive takes son, mon or ton before a vowel, and leaves an aspirated h alone
    Then French Grammar Renew: the language worker turns "<input>" into "<output>"

    Examples:
      | input     | output     |
      | sa epee   | son epee   |
      | ma arme   | mon arme   |
      | ta armure | ton armure |
      | sa hache  | sa hache   |
      | sa table  | sa table   |

  Scenario: elision reaches across a rich text tag, where the engine alone stops at it
    Then French Grammar Renew: the language worker turns "de <color=#D09B61FF>Eclat</color>" into "d'<color=#D09B61FF>Eclat</color>"
    And French Grammar Renew: the language worker turns "la <color=#D09B61FF>epee</color>" into "l'<color=#D09B61FF>epee</color>"

  Scenario: the definite article is rebuilt for an aspirated h, and only for one
    Then French Grammar Renew: the definite article of "husky" as a male is "le husky"
    And French Grammar Renew: the definite article of "hache" as a female is "la hache"
    And French Grammar Renew: the definite article of "herbe" as a female is "l'herbe"

  # A species noun keeps its own gender whatever the sex of the animal. The pawn is built for real and the rules
  # the game builds for it are read: the path the engine takes to write a sentence about an animal.
  Scenario: a species keeps its own grammatical gender
    Given the save "test-colony" is loaded
    Then French Grammar Renew: a male "Megaspider" is introduced with the definite article "la"
    And French Grammar Renew: a female "Muffalo" is introduced with the definite article "le"

  # Off by default: not every font has the narrow no-break space. The colon takes a no-break space and the
  # three high punctuation marks a narrow one; a clock time and a URL are left alone.
  Scenario: typography does nothing until it is switched on, then spaces only what ends a clause
    Then French Grammar Renew: the typography setting reads off
    And French Grammar Renew: the language worker leaves "Vraiment ?" unchanged
    When French Grammar Renew: the typography setting is turned on
    Then French Grammar Renew: the language worker turns "Vraiment ?" into "Vraiment ?"
    And French Grammar Renew: the language worker turns "Attention !" into "Attention !"
    And French Grammar Renew: the language worker turns "Ces colons sont affames :" into "Ces colons sont affames :"
    And French Grammar Renew: the language worker leaves "il est 12:00 ici" unchanged

  # Each switch turns off its own correction, and takes effect on the next string, without a restart.
  Scenario: every switch is read on each call
    When French Grammar Renew: the aspirated setting is turned off
    Then French Grammar Renew: the language worker turns "de hache" into "d'hache"
    When French Grammar Renew: the aspirated setting is turned on
    Then French Grammar Renew: the language worker turns "de hache" into "de hache"
    When French Grammar Renew: the possessive setting is turned off
    Then French Grammar Renew: the language worker leaves "sa epee" unchanged
    When French Grammar Renew: the possessive setting is turned on
    Then French Grammar Renew: the language worker turns "sa epee" into "son epee"
    When French Grammar Renew: the richtext setting is turned off
    Then French Grammar Renew: the language worker leaves "de <color=#D09B61FF>Eclat</color>" unchanged
    And no errors were logged
