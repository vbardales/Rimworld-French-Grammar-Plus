# TESTING.md, scenario 12. Plays in the ENGLISH pass only: the French pass leaves this file out by name.
#
# The mod patches unconditionally, because the language can be changed from the options screen without a
# restart, and every patch is inert unless the worker is French. The offline suite proves that with the English
# and German workers of the game and a null one. What only the game shows is the same in a running English
# game, with the patches really installed: nothing acquires a French article, a possessive or a no-break space.
#
# The language is chosen when the game starts, never during a run, so the switch itself is not a scenario: it is
# the two passes taken together.
Feature: in an English game the mod stays out of the way

  Background:
    Given French Grammar Renew: the settings are at their documented defaults

  Scenario: the patches are installed and change nothing
    Then French Grammar Renew: the three corrections are installed
    And French Grammar Renew: the language worker leaves "sa epee" unchanged
    And French Grammar Renew: the language worker leaves "de hache" unchanged
    And French Grammar Renew: the language worker leaves "de <color=#D09B61FF>Eclat</color>" unchanged

  # Typography switched on: the setting is asked to do its worst.
  Scenario: even with typography on nothing is spaced
    When French Grammar Renew: the typography setting is turned on
    Then French Grammar Renew: the language worker leaves "Really ?" unchanged
    And French Grammar Renew: the language worker leaves "Warning :" unchanged

  Scenario: an animal keeps the article the game gives it
    Given the save "test-colony" is loaded
    Then French Grammar Renew: a male "Megaspider" is introduced with the definite article "the"
    And French Grammar Renew: a female "Muffalo" is introduced with the definite article "the"
    And no errors were logged
