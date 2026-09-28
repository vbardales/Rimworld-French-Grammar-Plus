# MOD_SETTINGS.md, "Shortcut integration": in RIMMSQOL, reveal the shortcut, open the same settings, hide it
# again. TESTING.md, scenario 14, step 4. Feature 04 tests THIS mod's side of that contract. This one drives
# RIMMSQOL itself, through the shared steps of PickleTools/RimmsqolSteps:
#
#   - RIMMSQOL's own list of main buttons offers FGP_Settings, and the entry a player would click reads hidden;
#   - RIMMSQOL reveals it (its own settings instance, its own write; the def's buttonVisible moves as a result),
#     the main bar then visits it, and the file RIMMSQOL wrote says so;
#   - the revealed button opens the same page as Mod options;
#   - hiding it again empties the bar, and forgetting the choice leaves nothing in RIMMSQOL's file.
#
# WHAT THIS DOES NOT DO: it does not click RIMMSQOL's checkbox. The steps make the calls the checkbox makes, so
# whether the checkbox is wired to them is read from RIMMSQOL's source, not shown. "The bar draws it" is worked
# out from the bar's own list and rule; the captures are what shows pixels, and nothing here says they do. That
# a revealed choice survives a restart is RIMMSQOL's own storage, and is not asserted for this mod.
#
# Played only by the pass "avec-rimmsqol": without RIMMSQOL staged the first step stops with a sentence. Every
# scenario is followed by a teardown that puts back whatever a step changed, pass or fail.
@review @rimmsqol @requires:MalteSchulze.RIMMSqol @requires:nelim.pickletools.rimmsqol @requires:nelim.pickletools.screenshotmode
Feature: RIMMSQOL reveals and hides the French Grammar Renew shortcut

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    Then mod "MalteSchulze.RIMMSqol" is loaded
    And RIMMSQOL is ready to be driven

  Scenario: RIMMSQOL's own list offers the shortcut, hidden, and the bar does not draw it
    Then RIMMSQOL's own list of main buttons offers "FGP_Settings"
    And RIMMSQOL shows the main button "FGP_Settings" as hidden
    And RIMMSQOL holds no choice for the main button "FGP_Settings"
    And the main bar does not draw the button "FGP_Settings"
    When RIMMSQOL's own window is opened on its list of main buttons
    Then RIMMSQOL's own window is open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "rimmsqol, its list of main buttons, with the french grammar shortcut"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  Scenario: revealed in RIMMSQOL the shortcut is drawn, and it opens the same page as Mod options
    When RIMMSQOL reveals the main button "FGP_Settings"
    Then RIMMSQOL shows the main button "FGP_Settings" as visible
    And RIMMSQOL's settings file records the main button "FGP_Settings" as visible
    And the main bar draws the button "FGP_Settings"
    When the main bar's button "FGP_Settings" is activated
    Then French Grammar Renew: the settings dialog is open for this mod
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "french grammar settings, opened by the shortcut RIMMSQOL revealed"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  # The last steps put RIMMSQOL back: this scenario's teardown would do it anyway, but a scenario that says it and
  # checks it cannot be mistaken for one that merely ended.
  Scenario: hidden again in RIMMSQOL the shortcut leaves the bar, and forgetting the choice leaves nothing behind
    Given RIMMSQOL reveals the main button "FGP_Settings"
    And the main bar draws the button "FGP_Settings"
    When RIMMSQOL hides the main button "FGP_Settings"
    Then RIMMSQOL shows the main button "FGP_Settings" as hidden
    And the main bar does not draw the button "FGP_Settings"
    And RIMMSQOL's settings file records the main button "FGP_Settings" as hidden
    When RIMMSQOL forgets its choice for the main button "FGP_Settings"
    Then RIMMSQOL holds no choice for the main button "FGP_Settings"
    And RIMMSQOL's settings file records no choice for the main button "FGP_Settings"
    And the main bar does not draw the button "FGP_Settings"
    And no errors were logged
