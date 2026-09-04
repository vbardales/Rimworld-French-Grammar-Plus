using UnityEngine;
using Verse;

namespace FrenchGrammarPlus
{
	public class Settings : ModSettings
	{
		public bool fixRichTextElision = true;
		public bool fixAspiratedH = true;
		public bool fixPossessive = true;
		public bool fixPawnKindGender = true;

		// Off by default: the narrow no-break space is missing from some fonts, where it shows
		// as a blank box. Anyone who wants it can see for themselves in one click.
		public bool frenchTypography = false;

		public bool verboseLogging = false;

		public override void ExposeData()
		{
			base.ExposeData();
			Scribe_Values.Look(ref fixRichTextElision, "fixRichTextElision", true);
			Scribe_Values.Look(ref fixAspiratedH, "fixAspiratedH", true);
			Scribe_Values.Look(ref fixPossessive, "fixPossessive", true);
			Scribe_Values.Look(ref fixPawnKindGender, "fixPawnKindGender", true);
			Scribe_Values.Look(ref frenchTypography, "frenchTypography", false);
			Scribe_Values.Look(ref verboseLogging, "verboseLogging", false);
		}

		public void Draw(Rect inRect)
		{
			Listing_Standard list = new Listing_Standard();
			list.Begin(inRect);

			list.CheckboxLabeled("FGP.RichText".Translate(), ref fixRichTextElision, "FGP.RichText.Tip".Translate());
			list.CheckboxLabeled("FGP.AspiratedH".Translate(), ref fixAspiratedH, "FGP.AspiratedH.Tip".Translate());
			list.CheckboxLabeled("FGP.Possessive".Translate(), ref fixPossessive, "FGP.Possessive.Tip".Translate());
			list.CheckboxLabeled("FGP.KindGender".Translate(), ref fixPawnKindGender, "FGP.KindGender.Tip".Translate());

			list.GapLine();
			list.CheckboxLabeled("FGP.Typography".Translate(), ref frenchTypography, "FGP.Typography.Tip".Translate());

			list.GapLine();
			list.CheckboxLabeled("FGP.Verbose".Translate(), ref verboseLogging, "FGP.Verbose.Tip".Translate());

			list.Gap();
			Text.Font = GameFont.Tiny;
			list.Label("FGP.DataFiles".Translate());
			Text.Font = GameFont.Small;

			list.End();
		}
	}
}
