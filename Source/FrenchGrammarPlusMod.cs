using HarmonyLib;
using UnityEngine;
using Verse;

namespace FrenchGrammarPlus
{
	public class FrenchGrammarPlusMod : Mod
	{
		public const string PackageId = "nelim.frenchgrammarplus";

		public static Settings Settings { get; private set; }

		public FrenchGrammarPlusMod(ModContentPack content) : base(content)
		{
			Settings = GetSettings<Settings>();
			Lexicon.Load(content);

			// Patched unconditionally rather than only when French is active: the language can be
			// changed from the options screen without restarting, and every patch here hangs off
			// LanguageWorker_French, so it costs nothing while another language is loaded.
			Patcher.Run(new Harmony(PackageId));
		}

		public override string SettingsCategory() => "French Grammar Plus";

		public override void DoSettingsWindowContents(Rect inRect) => Settings.Draw(inRect);
	}
}
