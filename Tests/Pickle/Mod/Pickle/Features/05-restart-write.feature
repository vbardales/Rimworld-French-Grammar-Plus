# TESTING.md, scenario 14, step 3 (settings survive a restart). The WRITER of a two-launch restart test: run it
# first, then 06-restart-read.feature in a second process, under one hold of the lock:
#
#   -Filter '05-restart-write' -Then '06-restart-read'
#
# The last step writes the file the game's own mod class writes, so a scenario that fails before it leaves
# nothing. The values are chosen away from every default, so that a reader which finds defaults has proved
# nothing: gender off, typography on, verbose on.
Feature: settings written in one launch (restart test, part one)

  Scenario: a mixed combination is written to disk
    Given French Grammar Renew: the settings are at their documented defaults
    When French Grammar Renew: the gender setting is turned off
    And French Grammar Renew: the typography setting is turned on
    And French Grammar Renew: the verbose setting is turned on
    Then French Grammar Renew: the gender setting reads off
    And French Grammar Renew: the typography setting reads on
    And French Grammar Renew: the verbose setting reads on
    When French Grammar Renew: the settings are written to disk
