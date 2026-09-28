# TESTING.md, scenarios 11 and 14, the parts a running game is needed for. Plays in every pass; in the French pass
# the captures show the French page.
#
# The defaults, the save and reload of all 64 combinations, the shortcut's Def and its worker contract are proved
# outside the game (_tools/Run-Tests.ps1). What only a game shows is that the real Dialog_ModSettings draws the
# page, that it belongs to THIS mod, that the shortcut and Mod options lead to the same one, and how it reads.
#
# Revealing the shortcut in RIMMSQOL is not here: RIMMSQOL is not in the default staging. It is 07, played by the
# "avec-rimmsqol" pass. This feature is the contract on THIS mod's side, in every pass, with nothing else installed.
#
# The captures are @review: a green one says the path ran, not that the page fits its columns or that a French
# text is not accented gibberish. A person opens them.
@review @requires:nelim.pickletools.screenshotmode
Feature: the settings page and its hidden shortcut

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And French Grammar Renew: the settings are at their documented defaults

  Scenario: hidden by default, and it opens this mod's own page when activated
    Then French Grammar Renew: the shortcut is hidden on a clean configuration
    When French Grammar Renew: the shortcut is activated
    Then French Grammar Renew: the settings dialog is open for this mod
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "french grammar settings, opened by the shortcut"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  Scenario: the Mod options entry opens the same page, in the language of the pass
    When French Grammar Renew: the settings dialog is opened from Mod options
    Then French Grammar Renew: the settings dialog is open for this mod
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "french grammar settings, opened from mod options"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  Scenario: the six settings start where the documentation says
    Then French Grammar Renew: the richtext setting reads on
    And French Grammar Renew: the aspirated setting reads on
    And French Grammar Renew: the possessive setting reads on
    And French Grammar Renew: the gender setting reads on
    And French Grammar Renew: the typography setting reads off
    And French Grammar Renew: the verbose setting reads off
    And no errors were logged
