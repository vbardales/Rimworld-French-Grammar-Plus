namespace FrenchGrammarPlus
{
	/// <summary>
	/// Wraps the vanilla French post-processing: shield aspirated words on the way in, apply the
	/// rules vanilla cannot express on the way out.
	/// </summary>
	internal static class PostProcessedPatch
	{
		// "str" must match the parameter name in LanguageWorker_French.PostProcessed. If Ludeon
		// renames it, Patcher logs the failure and this correction goes quiet.
		internal static void Prefix(ref string str)
		{
			str = FrenchGrammar.Shield(str);
		}

		internal static void Postfix(ref string __result)
		{
			__result = FrenchGrammar.Apply(__result);
		}
	}
}
