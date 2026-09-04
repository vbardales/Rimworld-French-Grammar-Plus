using System;
using System.Text.RegularExpressions;
using Verse;

namespace FrenchGrammarPlus
{
	/// <summary>
	/// The string rules themselves. Everything the engine already does correctly in 1.6 is
	/// absent on purpose: elision, de+le, a+le and the plural exceptions all live in vanilla
	/// LanguageWorker_French since Ludeon adopted them from the old LanguageWorker_French mod.
	/// What is left here are the cases the vanilla regexes cannot reach.
	///
	/// Every accented literal is written as a \u escape so this file stays pure ASCII on disk
	/// and cannot be mangled by a compiler reading it in the machine's codepage. Inside a
	/// verbatim string the escape is resolved by the regex engine rather than by C#, which is
	/// exactly what we want for the patterns.
	/// </summary>
	public static class FrenchGrammar
	{
		// Same set as vanilla LanguageWorker_French, y excluded like vanilla.
		private const string Vowels =
			@"a\u00E0\u00E2\u00E4\u00E6e\u00E9\u00E8\u00EA\u00EBi\u00EE\u00EFo\u00F4\u00F6\u0153u\u00F9\u00FB\u00FC";
		private const string VowelsH = Vowels + "h";

		// A rich text tag: <color=#RRGGBBAA>, </color>, <b>, <size=20>...
		private const string Tag = @"(<[^>]*>)";

		// Zero-width space, dropped on the way out. Inserted before an aspirated word so the
		// vanilla elision regexes, which run between our prefix and our postfix, fail to match
		// it. Blocking vanilla is cheaper and far less brittle than undoing its work after.
		public const string Guard = "\u200B";

		private const string Nbsp = "\u00A0";   // no-break space, before ':'
		private const string Nnbsp = "\u202F";  // narrow no-break space, before ';' '!' '?'

		private const RegexOptions Opts = RegexOptions.Compiled | RegexOptions.IgnoreCase;

		// The same four rules as vanilla, but with a tag between the two words. The tag group is
		// mandatory here: the tagless case is vanilla's job and rerunning it would be waste.
		private static readonly Regex ElisionE =
			new Regex(@"\b([cdjlmnst]|qu|quoiqu|lorsqu)e " + Tag + "([" + VowelsH + "])", Opts);

		private static readonly Regex ElisionLa =
			new Regex(@"\b(l)a " + Tag + "([" + VowelsH + "])", Opts);

		// The trailing whitespace is captured, not assumed: swallowing a newline here would
		// silently reflow a letter. Groups: 1 word, 2 tag, 3 plural s, 4 whitespace.
		private static readonly Regex DeLe =
			new Regex(@"\b(d)e " + Tag + @"le(s?)(\s)", Opts);

		private static readonly Regex ALe =
			new Regex(@"(\u00E0) " + Tag + @"le(s?)(\s)", Opts);

		// Vanilla has no possessive rule at all, so this one also covers the tagless case.
		private static readonly Regex PossessiveVowel =
			new Regex(@"\b([mst])a ((?:<[^>]*>)?)([" + VowelsH + "])", Opts);

		// A colon only takes a space when it ends a clause, which leaves "12:00" and "http://"
		// alone. Any space already there is absorbed rather than doubled.
		private static readonly Regex BeforeColon =
			new Regex(@"(?<=[^\s:])[ \u00A0\u202F]?:(?=\s|$)", RegexOptions.Compiled);

		private static readonly Regex BeforeHighPunctuation =
			new Regex(@"(?<=[^\s!?;])[ \u00A0\u202F]?([!?;]+)", RegexOptions.Compiled);

		/// <summary>
		/// Shields aspirated words from the vanilla elision rules. Runs before them.
		/// </summary>
		public static string Shield(string str)
		{
			if (str.NullOrEmpty() || !FrenchGrammarPlusMod.Settings.fixAspiratedH)
				return str;

			// Cheap reject: most strings have no h and no "onz" anywhere.
			if (str.IndexOf('h') < 0 && str.IndexOf('H') < 0
				&& str.IndexOf("onz", StringComparison.OrdinalIgnoreCase) < 0)
				return str;

			return Lexicon.WordsInH.Replace(str,
				m => Lexicon.IsAspirated(m.Value) ? Guard + m.Value : m.Value);
		}

		/// <summary>
		/// Everything that has to happen after the vanilla rules have had their turn.
		/// </summary>
		public static string Apply(string str)
		{
			if (str.NullOrEmpty())
				return str;

			Settings s = FrenchGrammarPlusMod.Settings;

			if (s.fixRichTextElision && str.IndexOf('<') >= 0)
			{
				str = DeLe.Replace(str, m => Contract(m, "du", "des"));
				str = ALe.Replace(str, m => Contract(m, "au", "aux"));
				str = ElisionE.Replace(str, "$1'$2$3");
				str = ElisionLa.Replace(str, "$1'$2$3");
			}

			if (s.fixPossessive)
				str = PossessiveVowel.Replace(str, "$1on $2$3");

			if (s.frenchTypography)
			{
				str = BeforeColon.Replace(str, Nbsp + ":");
				str = BeforeHighPunctuation.Replace(str, Nnbsp + "$1");
			}

			// The guard must outlive every rule above: it is what keeps "sa hache" from becoming
			// "son hache" just as much as what kept "le haricot" whole.
			if (str.IndexOf(Guard[0]) >= 0)
				str = str.Replace(Guard, "");

			return str;
		}

		/// <summary>
		/// Builds "du"/"des"/"au"/"aux", carrying over the capital of the source word and putting
		/// the tag back where it belongs: hugging the noun, after the whitespace.
		/// </summary>
		private static string Contract(Match m, string singular, string plural)
		{
			string word = m.Groups[3].Value.Length > 0 ? plural : singular;

			if (char.IsUpper(m.Groups[1].Value[0]))
				word = char.ToUpperInvariant(word[0]) + word.Substring(1);

			return word + m.Groups[4].Value + m.Groups[2].Value;
		}

		/// <summary>
		/// Undoes the elision vanilla applies inside WithDefiniteArticle, which builds its
		/// article directly instead of going through the post-processing rules.
		/// </summary>
		public static void FixDefiniteArticle(ref string result, Gender gender)
		{
			if (!FrenchGrammarPlusMod.Settings.fixAspiratedH || result.NullOrEmpty() || result.Length < 3)
				return;

			if ((result[0] != 'l' && result[0] != 'L') || result[1] != '\'')
				return;

			string word = result.Substring(2);
			if (!Lexicon.IsAspirated(word))
				return;

			string article = gender == Gender.Female ? "la " : "le ";
			if (result[0] == 'L')
				article = char.ToUpperInvariant(article[0]) + article.Substring(1);

			result = article + word;
		}
	}
}
