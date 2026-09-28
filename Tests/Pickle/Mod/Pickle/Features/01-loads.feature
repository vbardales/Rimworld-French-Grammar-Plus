# TESTING.md, scenario 1 and the loading half of 13. Plays in every pass, English or French.
#
# The offline suite proves the three patch targets exist with the parameter names Harmony matches by, and that
# every Keyed key is in both languages. What only a running game shows is that Harmony really installed the
# three patches, that a game loads with them without an error, and that the texts exist in the language the
# pass runs. Loading is quiet by design: every patch is allowed to fail alone, with one red line, so "no errors
# were logged" is the assertion that carries the first half of this feature.
Feature: the mod loads, its three patches are installed and its texts exist

  Scenario: the mods are active and load in the documented order
    Then mod "brrainz.harmony" is loaded
    And mod "nelim.frenchgrammar" is loaded
    And mod "nelim.frenchgrammar" loads after "brrainz.harmony"

  Scenario: the settings shortcut the mod owns exists
    Then def "FGP_Settings" of type "MainButtonDef" exists

  Scenario: loading a game with the mod raises no error and no warning of its own
    Given the save "test-colony" is loaded
    Then no errors were logged
    And no warnings from mod "nelim.frenchgrammar"

  # Harmony's own record of who patched what: the patch is there, not merely a line claiming so.
  Scenario: the three corrections are installed
    Then French Grammar Renew: the three corrections are installed

  @requires:nelim.pickletools.loadaudit
  Scenario: the load of the mod is clean
    Given the save "test-colony" is loaded
    Then Nelim's Pickle Tools: the load of the mod "nelim.frenchgrammar" is clean

  Scenario: every text of the mod exists in the language this pass runs
    Then French Grammar Renew: every FGP text exists in the language this pass runs
    And French Grammar Renew: the settings title reads "French Grammar Renew"
