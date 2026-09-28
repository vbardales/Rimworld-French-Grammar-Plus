using System.Collections.Generic;
using System.Linq;
using FrenchGrammarPlus;
using HarmonyLib;
using RimWorld;
using RimWorks.Pickle;
using Verse;
using Verse.Grammar;

namespace FrenchGrammarRenew.PickleSteps
{
    /// <summary>
    /// What only a running game can show about the mod, and what the offline suite (_tools/Run-Tests.ps1)
    /// cannot: that Harmony really installed the three patches, and what the REAL, patched language worker
    /// makes of a string once the game has loaded everything.
    ///
    /// The offline suite already runs the mod's rules around the game's own LanguageWorker_French, so the
    /// rules themselves are proved on strings. These steps call the same public entry points the engine
    /// calls, PostProcessed and WithDefiniteArticle, on the worker the game is actually using: that is the
    /// step from "the rule is right" to "the patched game applies it".
    ///
    /// The language is never changed here. It is chosen at launch (Run-PickleWsl.ps1 -Language) and these
    /// steps assert against whichever language the pass runs.
    /// </summary>
    [PickleSteps]
    public class GrammarSteps
    {
        /// <summary>
        /// Harmony records who patched what. Asking it, rather than reading the log, says that the patch is
        /// there, not that a line claiming so was written. The three targets are the mod's own list.
        /// </summary>
        [Then("French Grammar Renew: the three corrections are installed")]
        public void AssertInstalled(PickleContext ctx)
        {
            var targets = new Dictionary<string, System.Reflection.MethodBase>
            {
                ["LanguageWorker_French.PostProcessed"] =
                    AccessTools.DeclaredMethod(typeof(LanguageWorker_French), "PostProcessed", new[] { typeof(string) }),
                ["LanguageWorker_French.WithDefiniteArticle"] =
                    AccessTools.DeclaredMethod(typeof(LanguageWorker_French), "WithDefiniteArticle"),
                ["GrammarUtility.RulesForPawn"] =
                    AccessTools.GetDeclaredMethods(typeof(GrammarUtility))
                        .FirstOrDefault(m => m.Name == "RulesForPawn"
                            && m.GetParameters().Any(p => p.ParameterType == typeof(PawnKindDef))),
            };

            var problems = new List<string>();
            foreach (var target in targets)
            {
                if (target.Value == null)
                {
                    problems.Add(target.Key + " does not exist in this game version (the mod would log it as an error)");
                    continue;
                }
                var info = Harmony.GetPatchInfo(target.Value);
                var owners = info == null
                    ? new List<string>()
                    : info.Prefixes.Concat(info.Postfixes).Select(p => p.owner).Distinct().ToList();
                if (!owners.Contains(FrenchGrammarPlusMod.PackageId))
                    problems.Add(target.Key + " is not patched by " + FrenchGrammarPlusMod.PackageId
                        + "; its patch owners are: " + (owners.Count == 0 ? "none" : string.Join(", ", owners.ToArray())));
            }
            ctx.Assert(problems.Count == 0, string.Join("; ", problems.ToArray()));
        }

        [Then("French Grammar Renew: the language worker turns {string} into {string}")]
        public void AssertTurns(PickleContext ctx, string input, string expected)
        {
            input = Driver.Unescape(input);
            expected = Driver.Unescape(expected);
            var got = Worker(ctx).PostProcessed(input);
            ctx.Assert(got == expected,
                $"in {Driver.Language(ctx)} the worker turned '{Driver.Show(input)}' into '{Driver.Show(got)}', "
                + $"expected '{Driver.Show(expected)}'");
        }

        [Then("French Grammar Renew: the language worker leaves {string} unchanged")]
        public void AssertUnchanged(PickleContext ctx, string input)
        {
            input = Driver.Unescape(input);
            var got = Worker(ctx).PostProcessed(input);
            ctx.Assert(got == input,
                $"in {Driver.Language(ctx)} the worker changed '{Driver.Show(input)}' into '{Driver.Show(got)}'; "
                + "this mod must leave every language but French alone");
        }

        /// <summary>
        /// The mod puts a zero-width space in front of an aspirated word, so that the engine's rules leave it
        /// alone, and takes it out afterwards. A guard that survives is invisible on screen and shows only as
        /// a gap, so it is asserted by value.
        /// </summary>
        [Then("French Grammar Renew: the language worker leaves no zero-width space in {string}")]
        public void AssertNoGuard(PickleContext ctx, string input)
        {
            var got = Worker(ctx).PostProcessed(Driver.Unescape(input));
            ctx.Assert(!got.Contains("​"),
                $"the worker's answer to '{Driver.Show(input)}' still carries the zero-width guard: '{Driver.Show(got)}'");
        }

        [Then("French Grammar Renew: the definite article of {string} as a {word} is {string}")]
        public void AssertDefiniteArticle(PickleContext ctx, string label, string gender, string expected)
        {
            var got = Worker(ctx).WithDefiniteArticle(label, GenderOf(ctx, gender));
            ctx.Assert(got == Driver.Unescape(expected),
                $"WithDefiniteArticle('{label}', {gender}) gave '{Driver.Show(got)}', expected '{Driver.Show(Driver.Unescape(expected))}'");
        }

        /// <summary>
        /// A species noun keeps its own gender whatever the sex of the animal. The pawn is built for real and
        /// the rules the game builds for it are read, which is the path the engine takes when it writes a
        /// sentence about an animal: RulesForPawn, then the ANIMAL_definite rule. Only the start of the text is
        /// compared, because the label after the article is the game's own and is translated.
        /// </summary>
        [Then("French Grammar Renew: a {word} {string} is introduced with the definite article {string}")]
        public void AssertSpeciesArticle(PickleContext ctx, string gender, string kindDefName, string article)
        {
            ctx.Require(Current.Game != null, "no game is running: load the fixture before this step");
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(kindDefName);
            ctx.Require(kind != null, $"no PawnKindDef named '{kindDefName}' in this game");

            var pawn = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                kind, faction: null, context: PawnGenerationContext.NonPlayer,
                forceGenerateNewPawn: true, fixedGender: GenderOf(ctx, gender)));
            try
            {
                var rules = GrammarUtility.RulesForPawn("ANIMAL", pawn).ToList();
                var definite = rules.OfType<Rule_String>().FirstOrDefault(r => r.keyword == "ANIMAL_definite");
                ctx.Require(definite != null,
                    "RulesForPawn gave no ANIMAL_definite rule; it gave: "
                    + string.Join(", ", rules.Select(r => r.keyword).Distinct().ToArray()));

                var text = definite.Generate();
                ctx.Assert(text.StartsWith(article + " ") || text.StartsWith(article + "'"),
                    $"a {gender} {kindDefName} was introduced as '{Driver.Show(text)}' in {Driver.Language(ctx)}; "
                    + $"expected it to start with the article '{article}'");
            }
            finally
            {
                pawn.Discard(true);
            }
        }

        private static LanguageWorker Worker(PickleContext ctx)
        {
            var worker = Find.ActiveLanguageWorker;
            ctx.Require(worker != null, "Find.ActiveLanguageWorker is null: the game has not finished loading a language");
            return worker;
        }

        private static Gender GenderOf(PickleContext ctx, string word)
        {
            switch ((word ?? "").ToLowerInvariant())
            {
                case "male": return Gender.Male;
                case "female": return Gender.Female;
                default:
                    ctx.Require(false, $"'{word}' is not a gender: write male or female");
                    return Gender.None;
            }
        }
    }
}
