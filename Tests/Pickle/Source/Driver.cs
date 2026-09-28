using System.Reflection;
using System.Text.RegularExpressions;
using FrenchGrammarPlus;
using RimWorks.Pickle;
using Verse;

namespace FrenchGrammarRenew.PickleSteps
{
    /// <summary>
    /// Shared lookups for every step class here. Nothing is cached: a save reload replaces every
    /// object in the game. And every miss names itself: a report keeps no stack trace, so an
    /// unguarded hop comes back as "Object reference not set" and the run is already over.
    /// </summary>
    public static class Driver
    {
        internal const BindingFlags InstanceAny = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;

        public static FrenchGrammarPlusMod Mod(PickleContext ctx)
        {
            var mod = FrenchGrammarPlusMod.Instance;
            ctx.Require(mod != null,
                "FrenchGrammarPlusMod.Instance is null: FrenchGrammarPlus.dll is not loaded in this session, "
                + "so no step here can reach the settings or the patches");
            return mod;
        }

        public static string Language(PickleContext ctx)
        {
            var folder = LanguageDatabase.activeLanguage?.folderName;
            ctx.Require(!string.IsNullOrEmpty(folder), "no active language: the game has not finished loading one");
            return folder;
        }

        /// <summary>
        /// A feature line is plain text, and the two characters this mod exists to place, the zero-width
        /// space and the narrow no-break space, are invisible in it. So a step accepts \uXXXX and
        /// resolves it, and its failure message shows the characters the same way.
        /// </summary>
        public static string Unescape(string s)
            => s == null ? null : Regex.Replace(s, @"\\u([0-9A-Fa-f]{4})",
                m => ((char)System.Convert.ToInt32(m.Groups[1].Value, 16)).ToString());

        public static string Show(string s)
        {
            if (s == null) return "null";
            var sb = new System.Text.StringBuilder();
            foreach (char c in s)
                sb.Append(c > 126 || c < 32 ? "\\u" + ((int)c).ToString("X4") : c.ToString());
            return sb.ToString();
        }
    }
}
