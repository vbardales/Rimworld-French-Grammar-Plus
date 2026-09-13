using HarmonyLib;
using UnityEngine;
using Verse;

namespace FrenchGrammarPlus
{
	public class FrenchGrammarPlusMod : Mod
	{
		public const string PackageId = "nelim.frenchgrammarplus";

		public static Settings Settings { get; private set; }
		public static FrenchGrammarPlusMod Instance { get; private set; }

		public FrenchGrammarPlusMod(ModContentPack content) : base(content)
		{
			Instance = this;
			Settings = GetSettings<Settings>();
			Lexicon.Load(content);

			// Patched unconditionally rather than only when French is active: the language can be
			// changed from the options screen. Worker patches target French only; the global
			// pawn-rules patch checks the active worker on each call.
			Patcher.Run(new Harmony(PackageId));
		}

		public override string SettingsCategory() => "FGP.SettingsTitle".Translate();

		public override void DoSettingsWindowContents(Rect inRect) => Settings.Draw(inRect);
	}
}
