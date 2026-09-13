using RimWorld;
using Verse;

namespace FrenchGrammarPlus
{
	/// <summary>Optional access to the same native dialog used by Mod options.</summary>
	public sealed class MainButtonWorker_Settings : MainButtonWorker
	{
		public override void Activate()
		{
			Find.WindowStack.Add(new Dialog_ModSettings(FrenchGrammarPlusMod.Instance));
		}
	}
}
