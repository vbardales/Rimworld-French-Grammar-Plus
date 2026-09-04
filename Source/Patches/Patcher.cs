using System;
using System.Linq;
using System.Reflection;
using HarmonyLib;
using RimWorld;
using Verse;
using Verse.Grammar;

namespace FrenchGrammarPlus
{
	/// <summary>
	/// Patches are wired by hand rather than with PatchAll, and every one of them is allowed to
	/// fail on its own. A LanguageWorker mod outlives several game versions; when Ludeon renames
	/// a method or a parameter, the right outcome is one red line in the log naming the feature
	/// that stopped working, not a mod that refuses to load.
	/// </summary>
	internal static class Patcher
	{
		internal static void Run(Harmony harmony)
		{
			// DeclaredMethod, never Method: if a future version drops the French override,
			// AccessTools.Method would walk up and hand us LanguageWorker.PostProcessed, and we
			// would be rewriting German and Korean too.
			TryPatch(harmony,
				AccessTools.DeclaredMethod(typeof(LanguageWorker_French), "PostProcessed", new[] { typeof(string) }),
				"LanguageWorker_French.PostProcessed",
				prefix: Method(typeof(PostProcessedPatch), nameof(PostProcessedPatch.Prefix)),
				postfix: Method(typeof(PostProcessedPatch), nameof(PostProcessedPatch.Postfix)));

			TryPatch(harmony,
				AccessTools.DeclaredMethod(typeof(LanguageWorker_French), "WithDefiniteArticle"),
				"LanguageWorker_French.WithDefiniteArticle",
				postfix: Method(typeof(DefiniteArticlePatch), nameof(DefiniteArticlePatch.Postfix)));

			TryPatch(harmony,
				RulesForPawn(),
				"GrammarUtility.RulesForPawn",
				postfix: Method(typeof(RulesForPawnPatch), nameof(RulesForPawnPatch.Postfix)));
		}

		/// <summary>
		/// Resolved by shape, not by signature. The old LanguageWorker_French mod asked for an
		/// exact list of fifteen parameter types and stopped working the day Royalty added one;
		/// "the RulesForPawn that takes a PawnKindDef" survives every DLC.
		/// </summary>
		private static MethodBase RulesForPawn()
		{
			return AccessTools.GetDeclaredMethods(typeof(GrammarUtility))
				.FirstOrDefault(m => m.Name == "RulesForPawn"
					&& m.GetParameters().Any(p => p.ParameterType == typeof(PawnKindDef)));
		}

		private static MethodInfo Method(Type type, string name) => AccessTools.DeclaredMethod(type, name);

		private static void TryPatch(Harmony harmony, MethodBase target, string label,
			MethodInfo prefix = null, MethodInfo postfix = null)
		{
			if (target == null)
			{
				Log.Error($"[FrenchGrammarPlus] {label} is not present in this version of the game. "
					+ "The matching correction is disabled; the rest of the mod still works.");
				return;
			}

			try
			{
				harmony.Patch(target,
					prefix == null ? null : new HarmonyMethod(prefix),
					postfix == null ? null : new HarmonyMethod(postfix));

				if (FrenchGrammarPlusMod.Settings.verboseLogging)
					Log.Message($"[FrenchGrammarPlus] {label} patched.");
			}
			catch (Exception e)
			{
				// The usual cause is a renamed parameter: Harmony matches our arguments to the
				// original's by name, so "str" or "gender" changing is enough to land here.
				Log.Error($"[FrenchGrammarPlus] failed to patch {label}: {e.Message}");
			}
		}
	}
}
