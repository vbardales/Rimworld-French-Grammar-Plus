using System.Linq;
using FrenchGrammarPlus;
using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace FrenchGrammarRenew.PickleSteps
{
    /// <summary>
    /// The settings page, its optional MainButtons shortcut, and the keys they read. What the offline suite
    /// proves is the defaults, the save and reload of all 64 combinations, and the shortcut's Def and worker
    /// contract. What only a game shows is that the real Dialog_ModSettings draws the page, that it belongs to
    /// THIS mod, that the shortcut opens the same one, and that the text on it exists in the language of the pass.
    ///
    /// RIMMSQOL revealing the shortcut is not here: it is the shared steps of PickleTools/RimmsqolSteps, in the
    /// pass that mounts RIMMSQOL.
    /// </summary>
    [PickleSteps]
    public class SettingsSteps
    {
        private const string ShortcutDefName = "FGP_Settings";
        private const string Prefix = "FGP.";

        /// <summary>The six values, put back to what a clean profile starts with.</summary>
        [Given("French Grammar Renew: the settings are at their documented defaults")]
        public void ResetToDefaults(PickleContext ctx) => Reset();

        /// <summary>
        /// Nothing a scenario changes may leak into the next one, pass or fail. Only the values in memory are
        /// put back: a scenario that wants the file left as it is says so with "written to disk".
        /// </summary>
        [AfterScenario]
        public void RestoreAfterScenario(PickleContext ctx) => Reset();

        private static void Reset()
        {
            var s = FrenchGrammarPlusMod.Settings;
            if (s == null) return;
            s.fixRichTextElision = true;
            s.fixAspiratedH = true;
            s.fixPossessive = true;
            s.fixPawnKindGender = true;
            s.frenchTypography = false;
            s.verboseLogging = false;
        }

        [When("French Grammar Renew: the {word} setting is turned {word}")]
        public void Turn(PickleContext ctx, string name, string state)
        {
            ctx.Require(state == "on" || state == "off", $"'{state}' is not a state: write on or off");
            Write(ctx, name, state == "on");
        }

        [Then("French Grammar Renew: the {word} setting reads {word}")]
        public void AssertReads(PickleContext ctx, string name, string state)
        {
            ctx.Require(state == "on" || state == "off", $"'{state}' is not a state: write on or off");
            var value = Read(ctx, name);
            ctx.Assert(value == (state == "on"), $"the {name} setting reads {(value ? "on" : "off")}, expected {state}");
        }

        /// <summary>
        /// The write the settings window does when it closes, through the mod's own class, so that the file
        /// that lands is the one a restart will read.
        /// </summary>
        [When("French Grammar Renew: the settings are written to disk")]
        public void WriteToDisk(PickleContext ctx) => Driver.Mod(ctx).WriteSettings();

        private static bool Read(PickleContext ctx, string name)
        {
            var s = Driver.Mod(ctx) != null ? FrenchGrammarPlusMod.Settings : null;
            switch (name)
            {
                case "richtext": return s.fixRichTextElision;
                case "aspirated": return s.fixAspiratedH;
                case "possessive": return s.fixPossessive;
                case "gender": return s.fixPawnKindGender;
                case "typography": return s.frenchTypography;
                case "verbose": return s.verboseLogging;
                default:
                    ctx.Require(false, $"'{name}' is not a setting: richtext, aspirated, possessive, gender, typography or verbose");
                    return false;
            }
        }

        private static void Write(PickleContext ctx, string name, bool value)
        {
            Read(ctx, name); // validates the name and the mod
            var s = FrenchGrammarPlusMod.Settings;
            switch (name)
            {
                case "richtext": s.fixRichTextElision = value; break;
                case "aspirated": s.fixAspiratedH = value; break;
                case "possessive": s.fixPossessive = value; break;
                case "gender": s.fixPawnKindGender = value; break;
                case "typography": s.frenchTypography = value; break;
                case "verbose": s.verboseLogging = value; break;
            }
        }

        // ---------------------------------------------------------------- the shortcut

        /// <summary>
        /// MOD_SETTINGS.md: hidden by default, neither visible nor greyed out. Both halves are asked of the
        /// game's own worker, which is what the main bar asks, rather than of the field alone.
        /// </summary>
        [Then("French Grammar Renew: the shortcut is hidden on a clean configuration")]
        public void AssertHiddenByDefault(PickleContext ctx)
        {
            var def = Shortcut(ctx);
            ctx.Assert(!def.buttonVisible, $"{ShortcutDefName} ships with buttonVisible true: it would stand in everyone's main bar");
            ctx.Assert(!def.Worker.Visible, $"{ShortcutDefName} reports Visible true with buttonVisible false: it shows without anything having revealed it");
        }

        /// <summary>Activating the worker is what a revealed button ends up calling.</summary>
        [When("French Grammar Renew: the shortcut is activated")]
        public async System.Threading.Tasks.Task ActivateShortcut(PickleContext ctx)
        {
            Shortcut(ctx).Worker.Activate();
            await ctx.WaitFrames(3);
        }

        /// <summary>
        /// Waits for its own frames rather than leaving that to the scenario. Dialog_ModSettings force-pauses
        /// the game, so a tick wait in the scenario can never be satisfied. Frames still pass while paused.
        /// </summary>
        [When("French Grammar Renew: the settings dialog is opened from Mod options")]
        public async System.Threading.Tasks.Task OpenDialog(PickleContext ctx)
        {
            Find.WindowStack.Add(new Dialog_ModSettings(Driver.Mod(ctx)));
            await ctx.WaitFrames(3);
        }

        /// <summary>
        /// The claim is not "a settings window opened" but "the SAME settings opened": a dialog built for another
        /// mod would look identical in a screenshot, so the window is asked which mod it was built for.
        /// </summary>
        [Then("French Grammar Renew: the settings dialog is open for this mod")]
        public void AssertDialogFor(PickleContext ctx)
        {
            var stack = Find.WindowStack;
            ctx.Require(stack != null, "there is no window stack: no game and no main menu is running");

            var dialogs = stack.Windows.OfType<Dialog_ModSettings>().ToList();
            ctx.Assert(dialogs.Count > 0, "no Dialog_ModSettings is open");

            var mine = Driver.Mod(ctx);
            ctx.Assert(dialogs.Any(d => ModOf(ctx, d) == mine),
                "a settings dialog is open, but not this mod's: it was built for "
                + string.Join(", ", dialogs.Select(d => ModOf(ctx, d)?.Content?.Name ?? "an unknown mod").ToArray())
                + ". The shortcut and Mod options must lead to the same place");
        }

        /// <summary>
        /// Dialog_ModSettings keeps the mod it was built for in a private field whose name has moved between
        /// game versions: the first Mod-typed field is taken, and a miss lists what exists.
        /// </summary>
        private static Mod ModOf(PickleContext ctx, Dialog_ModSettings dialog)
        {
            var type = typeof(Dialog_ModSettings);
            var field = type.GetFields(Driver.InstanceAny).FirstOrDefault(f => typeof(Mod).IsAssignableFrom(f.FieldType));
            ctx.Require(field != null,
                "Dialog_ModSettings holds no Mod field in this version; it has: "
                + string.Join(", ", type.GetFields(Driver.InstanceAny).Select(f => f.Name).ToArray()));
            return field.GetValue(dialog) as Mod;
        }

        private static MainButtonDef Shortcut(PickleContext ctx)
        {
            var def = DefDatabase<MainButtonDef>.GetNamedSilentFail(ShortcutDefName);
            ctx.Require(def != null, $"no MainButtonDef named '{ShortcutDefName}': the shortcut a customization mod is meant to reveal is not shipped");
            return def;
        }

        // ---------------------------------------------------------------- translations

        /// <summary>
        /// Every Keyed key the English resources declare must have text in the ACTIVE language's own resources.
        /// Comparing against the English list, rather than a hand-kept one, means a key added to the mod without
        /// a French entry fails here even if this suite never heard of it. In developer mode, which every Pickle
        /// run is, a key missing from the active language does not fall back to plain English: it is printed as
        /// accented letters, so gibberish in a capture is a missing key, and clean English inside a French
        /// interface is a literal that never went through Translate.
        /// </summary>
        [Then("French Grammar Renew: every FGP text exists in the language this pass runs")]
        public void AssertEveryKeyExists(PickleContext ctx)
        {
            var active = LanguageDatabase.activeLanguage;
            ctx.Require(active != null, "no active language: the game has not finished loading one");
            var english = LanguageDatabase.defaultLanguage;

            var keys = english.keyedReplacements.Keys.Where(k => k.StartsWith(Prefix)).ToList();
            ctx.Assert(keys.Count >= 15,
                $"only {keys.Count} English keys start with '{Prefix}', the mod owns 15: the English resources did "
                + "not load, or a key was removed without updating this suite");

            var missing = keys.Where(k => !active.HaveTextForKey(k)).ToList();
            ctx.Assert(missing.Count == 0,
                $"{active.folderName} has no text for {missing.Count} key(s): " + string.Join(", ", missing.ToArray()));
        }

        /// <summary>The title of the page in Mod options is the mod's name, in both languages.</summary>
        [Then("French Grammar Renew: the settings title reads {string}")]
        public void AssertTitle(PickleContext ctx, string expected)
        {
            var got = Driver.Mod(ctx).SettingsCategory();
            ctx.Assert(got == expected, $"the settings title reads '{Driver.Show(got)}' in {Driver.Language(ctx)}, expected '{expected}'");
        }
    }
}
