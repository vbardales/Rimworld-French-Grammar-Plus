# TESTING.md, scenario 14, step 3. The READER of the restart test: it plays in a second process, started after the
# writer of 05-restart-write.feature, and never on its own (run alone it fails, which is right: the file holds
# whatever the previous run left).
#
# The mod reads its file in its constructor, so a fresh process is the only honest reader. It asserts the values
# the writer chose, then puts the DEFAULTS back on disk, not only in memory: a pass without a seed inherits the
# settings file the previous run left, and a reader that leaves the writer's values behind hands them to the
# next run of this mod.
Feature: settings read back in the next launch (restart test, part two)

  Scenario: the values written by the previous launch are in place, and the defaults are put back
    Then French Grammar Renew: the gender setting reads off
    And French Grammar Renew: the typography setting reads on
    And French Grammar Renew: the verbose setting reads on
    And French Grammar Renew: the aspirated setting reads on
    When French Grammar Renew: the settings are at their documented defaults
    And French Grammar Renew: the settings are written to disk
    Then French Grammar Renew: the gender setting reads on
    And French Grammar Renew: the typography setting reads off
    And no errors were logged
