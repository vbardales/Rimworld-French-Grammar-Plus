using Verse;

namespace FrenchGrammarPlus
{
	/// <summary>
	/// WithDefiniteArticle builds "l'" itself instead of going through the post-processing
	/// rules, so the shield never sees it and the fix has to happen here.
	/// </summary>
	internal static class DefiniteArticlePatch
	{
		internal static void Postfix(ref string __result, Gender gender)
		{
			FrenchGrammar.FixDefiniteArticle(ref __result, gender);
		}
	}
}
