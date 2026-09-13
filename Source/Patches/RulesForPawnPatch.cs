using System;
using System.Collections.Generic;
using System.Linq;
using Verse;
using Verse.Grammar;

namespace FrenchGrammarPlus
{
	/// <summary>
	/// A species noun has a grammatical gender of its own, unrelated to the sex of the animal
	/// wearing it: "la megaspider" stays feminine for a male. The engine has no way to know that,
	/// so it uses the pawn's sex for both and writes "le megaspider".
	///
	/// The old mod fixed this by writing to kind.label during the call and restoring it after --
	/// a global mutation on a shared def, on a lazily enumerated method. This rebuilds the three
	/// affected rules from the label the engine itself produced instead, and touches nothing that
	/// outlives the call.
	/// </summary>
	internal static class RulesForPawnPatch
	{
		// Passthrough postfix: Harmony feeds us the original return value and takes back ours.
		// "pawnSymbol" and "kind" must match the original's parameter names.
		internal static IEnumerable<Rule> Postfix(IEnumerable<Rule> values, string pawnSymbol, PawnKindDef kind)
			=> Apply(values, pawnSymbol, kind, Find.ActiveLanguageWorker,
				gender => gender.GetPossessive(), message => Log.Message(message));

		internal static IEnumerable<Rule> Apply(IEnumerable<Rule> values, string pawnSymbol,
			PawnKindDef kind, LanguageWorker worker, Func<Gender, string> possessive, Action<string> log)
		{
			if (!(worker is LanguageWorker_French)
				|| !FrenchGrammarPlusMod.Settings.fixPawnKindGender
				|| !Lexicon.HasKindGenders
				|| kind == null
				|| !Lexicon.TryGetKindGender(kind.defName, out Gender gender))
			{
				// The common path stays lazy and allocation-free.
				return values;
			}

			return Rewrite(values, pawnSymbol, gender, worker, possessive, log);
		}

		private static IEnumerable<Rule> Rewrite(IEnumerable<Rule> values, string pawnSymbol,
			Gender gender, LanguageWorker worker, Func<Gender, string> possessive, Action<string> log)
		{
			List<Rule> rules = values.ToList();
			string prefix = pawnSymbol.NullOrEmpty() ? "" : pawnSymbol + "_";

			// Rebuild from the label the engine already resolved rather than from kind.label:
			// that way a translated, DLC-added or mod-added label is carried through untouched.
			string label = rules.OfType<Rule_String>()
				.FirstOrDefault(r => r.keyword == prefix + "label")
				?.Generate();

			if (label.NullOrEmpty())
				return rules;

			for (int i = 0; i < rules.Count; i++)
			{
				if (!(rules[i] is Rule_String rule))
					continue;

				if (rule.keyword == prefix + "definite")
					rules[i] = new Rule_String(rule.keyword, worker.WithDefiniteArticle(label, gender));
				else if (rule.keyword == prefix + "indefinite")
					rules[i] = new Rule_String(rule.keyword, worker.WithIndefiniteArticle(label, gender));
				else if (rule.keyword == prefix + "possessive")
					rules[i] = new Rule_String(rule.keyword, possessive(gender));
			}

			if (FrenchGrammarPlusMod.Settings.verboseLogging)
				log($"[FrenchGrammarPlus] gender overridden for '{label}' ({pawnSymbol}): {gender}.");

			return rules;
		}
	}
}
