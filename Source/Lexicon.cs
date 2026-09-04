using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Verse;

namespace FrenchGrammarPlus
{
	/// <summary>
	/// The two word lists the engine cannot know about, loaded from plain text files in the
	/// mod's Data folder so a translator can extend them without a compiler.
	/// </summary>
	public static class Lexicon
	{
		// Prefixes of words that refuse elision. Matched by prefix, so "hat" covers "hate".
		private static readonly List<string> AspiratedPrefixes = new List<string>();

		// PawnKindDef.defName -> grammatical gender of the species noun.
		private static readonly Dictionary<string, Gender> KindGender =
			new Dictionary<string, Gender>(StringComparer.OrdinalIgnoreCase);

		/// <summary>
		/// Matches any word starting with h (or "onz"), whatever its case. The aspirated test
		/// itself is done in the callback: a regex alternation of ninety prefixes would be both
		/// slower and unreadable, and words in h are rare enough that the callback is cheap.
		/// </summary>
		public static readonly Regex WordsInH =
			new Regex(@"\b[Hh][^\s<>]*|\b[Oo]nz[^\s<>]*", RegexOptions.Compiled);

		public static bool IsAspirated(string word)
		{
			if (word.NullOrEmpty())
				return false;

			string lower = word.ToLowerInvariant();
			for (int i = 0; i < AspiratedPrefixes.Count; i++)
			{
				if (lower.StartsWith(AspiratedPrefixes[i], StringComparison.Ordinal))
					return true;
			}
			return false;
		}

		public static bool TryGetKindGender(string defName, out Gender gender)
		{
			gender = Gender.None;
			return !defName.NullOrEmpty() && KindGender.TryGetValue(defName, out gender);
		}

		public static bool HasKindGenders => KindGender.Count > 0;

		public static void Load(ModContentPack content)
		{
			AspiratedPrefixes.Clear();
			KindGender.Clear();

			foreach (string line in ReadLines(content, "aspirated-h.txt"))
			{
				AspiratedPrefixes.Add(line.ToLowerInvariant());
			}

			foreach (string line in ReadLines(content, "pawnkind-gender.txt"))
			{
				int eq = line.IndexOf('=');
				if (eq <= 0 || eq == line.Length - 1)
				{
					Log.Warning($"[FrenchGrammarPlus] pawnkind-gender.txt: line ignored, expected defName=f|m: {line}");
					continue;
				}

				string defName = line.Substring(0, eq).Trim();
				string value = line.Substring(eq + 1).Trim().ToLowerInvariant();

				if (value == "f" || value == "female")
					KindGender[defName] = Gender.Female;
				else if (value == "m" || value == "male")
					KindGender[defName] = Gender.Male;
				else
					Log.Warning($"[FrenchGrammarPlus] pawnkind-gender.txt: unknown gender '{value}' for {defName}.");
			}

			// Longest prefix first: "haut" must win over a future "ha" entry.
			AspiratedPrefixes.Sort((a, b) => b.Length.CompareTo(a.Length));

			if (FrenchGrammarPlusMod.Settings.verboseLogging)
			{
				Log.Message($"[FrenchGrammarPlus] {AspiratedPrefixes.Count} aspirated-h words, "
					+ $"{KindGender.Count} species genders loaded.");
			}
		}

		/// <summary>
		/// Reads a data file as UTF-8 whatever the machine's codepage, dropping comments and
		/// blank lines. A missing or unreadable file is a warning, never a crash: the mod stays
		/// loadable with one feature short rather than taking the game down with it.
		/// </summary>
		private static IEnumerable<string> ReadLines(ModContentPack content, string fileName)
		{
			string path = Path.Combine(content.RootDir, Path.Combine("Data", fileName));

			if (!File.Exists(path))
			{
				Log.Warning($"[FrenchGrammarPlus] data file missing: {path}");
				yield break;
			}

			string[] lines;
			try
			{
				lines = File.ReadAllLines(path, Encoding.UTF8);
			}
			catch (Exception e)
			{
				Log.Warning($"[FrenchGrammarPlus] cannot read {fileName}: {e.Message}");
				yield break;
			}

			foreach (string raw in lines)
			{
				string line = raw.Trim();
				if (line.Length > 0 && line[0] != '#')
					yield return line;
			}
		}
	}
}
