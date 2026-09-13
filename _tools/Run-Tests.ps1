<#
.SYNOPSIS
  The mod's own test suite. Runs without RimWorld, in a couple of seconds.

.DESCRIPTION
  The original five groups contain twenty-six tests. Settings-Tests.ps1 adds seven regressions:
  native Scribe persistence, defaults, language isolation/logging, shortcut contract and XML/l10n.

    The grammar        every correction run against the game's own French rules
    The patch targets  the three methods the mod hangs off, and the parameter names Harmony
                       matches by
    The word lists     both files, against the defs the game actually ships
    Translations       every key the C# asks for, in English and in French, key for key
    What ships         the About, the folder Steam receives, and the documents beside it

  WHAT MAKES THIS SUITE WORTH HAVING. The game's own LanguageWorker_French loads and runs outside
  RimWorld. So the first group does not describe what the engine gets wrong, it asks it:

      Shield(s)  ->  the real LanguageWorker_French.PostProcessed(s)  ->  Apply(s)

  which is exactly the sandwich Harmony builds in game, with the real vanilla regexes in the
  middle. Every case in that group asserts two things: that vanilla alone still produces the
  fault, and that the mod's output is right. The first half is what keeps the suite honest - the
  day Ludeon fixes aspirated h themselves, those tests fail and say the correction is now
  redundant, rather than passing forever on a bug that is gone.

  Assembly-CSharp cannot be fully loaded outside the game - it references Unity assemblies that
  are not all there - and GetTypes() on it always throws. Nothing here calls it: only the handful
  of types these tests name are touched, and those resolve.

  The suite writes with Write-Output and never Write-Host: the output has to survive being piped
  into a file or a variable, which Write-Host does not.

  PURE ASCII, like the mod's own source. Accented test strings are written as \uXXXX and expanded
  by Fr() below, so no codepage and no missing byte-order mark can mangle this file. PowerShell
  5.1 reads a .ps1 without a BOM as ANSI, which is exactly the trap this avoids.

  NOT A FUNCTIONAL TEST. Nothing here loads the mod into RimWorld, draws the settings window,
  or puts an animal on a map. The rules are executed, the patches are not: Harmony never runs, so
  a target that resolves here can still fail to patch in game. The functional pass is TESTING.md,
  played in a colony, and its evidence is Player.log.

  THE ORIGINAL 26 TESTS HAVE BEEN SEEN TO FAIL, against a deliberately broken copy in a scratch
  directory, never against the real files. Sixteen mutations, each having to wake its own test:

    "hache" removed from aspirated-h.txt        -> the shield test, and three others that use
                                                   the word, each naming it
    "homme" added to aspirated-h.txt            -> the mute-h test, and the collision test
    an entry deleted from pawnkind-gender.txt   -> the coverage test and the header count
    "Muffalo=x" put in that file                -> the parse test
    a duplicate entry added                     -> the parse test, naming the species
    a species the game does not ship added      -> the other coverage test
    "115 entries" changed to "114"              -> the header count test, alone
    a French key deleted                        -> the key-for-key test
    an English key deleted                      -> the C# asks for it test, and key for key
    the packageId changed in About.xml          -> the packageId test, printing both
    an accented character put in a .cs file     -> the pure ASCII test
    TESTING.md copied into Mod/                 -> the what Steam receives test
    Mod/ATTRIBUTION.md deleted                  -> the same test, with the other message
    STATUS.md front matter unclosed             -> the front matter test
    a French field name in STATUS.md            -> the field names test
    the mod assembly removed                    -> all twelve tests that need it, saying so

  THE MUTATION PASS FOUND A HOLE IN THIS FILE, which is the whole point of running it. The last
  mutation originally woke nothing: the code tests began with `if (NeedCode) { return }`, which
  evaluates the guard's message as a boolean and throws it away, so a missing assembly left
  twelve tests silently passing and the suite announcing that everything was fine. They now emit
  it, and a missing DLL fails them by name.

.EXAMPLE
  powershell -NoProfile -File _tools/Run-Tests.ps1

.EXAMPLE
  # From Git Bash, where the machine's execution policy refuses a script file:
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1
#>

param(
    [string]$ModRoot  = (Split-Path -Parent $PSScriptRoot),
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed'
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------------------------
# Harness
# ---------------------------------------------------------------------------------------------

$script:ran = 0
$script:failed = 0

# A test body writes its problems to the pipeline and stays silent when it has none. No assertion
# vocabulary: one test that lists every offending case beats ten that stop at the first.
function It([string]$name, [scriptblock]$body) {
    $script:ran++
    $problems = @()
    try   { $problems = @(& $body | Where-Object { $_ }) }
    catch { $problems = @("threw: $($_.Exception.Message)") }

    if ($problems.Count -eq 0) {
        Write-Output "  ok    $name"
    } else {
        $script:failed++
        Write-Output "  FAIL  $name"
        foreach ($p in $problems) { Write-Output "          $p" }
    }
}

function Section([string]$name) { Write-Output ''; Write-Output $name }

# Expands \uXXXX so this file stays pure ASCII, the same trick and the same reason as the mod's
# own source. Written out rather than imported: the suite must not depend on the thing it tests.
function Fr([string]$s) {
    return [regex]::Replace($s, '\\u([0-9A-Fa-f]{4})',
        { param($m) [string][char][Convert]::ToInt32($m.Groups[1].Value, 16) })
}

# ---------------------------------------------------------------------------------------------
# The two assemblies, loaded outside the game
# ---------------------------------------------------------------------------------------------
#
# The guard against asking twice for the same name matters: an unresolvable name asked twice
# recurses to a stack overflow instead of erroring.

$script:probed = @{}
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    $p = Join-Path $Managed "$short.dll"
    if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

$anyFlags  = [Reflection.BindingFlags]'NonPublic,Public,Static,Instance'
$hereFlags = [Reflection.BindingFlags]'NonPublic,Public,Static,Instance,DeclaredOnly'

$modDir   = Join-Path $ModRoot 'Mod'
$dllPath  = Join-Path $modDir 'Assemblies\FrenchGrammarPlus.dll'
$csPath   = Join-Path $Managed 'Assembly-CSharp.dll'

$asm = $null; $csharp = $null
$tGrammar = $null; $tLexicon = $null; $tMod = $null; $tSettings = $null
$tWorker = $null; $worker = $null; $mPostProcessed = $null
$settings = $null

if ((Test-Path $dllPath) -and (Test-Path $csPath)) {
    $csharp   = [System.Reflection.Assembly]::LoadFrom($csPath)
    $tWorker  = $csharp.GetType('Verse.LanguageWorker_French')
    $worker   = [Activator]::CreateInstance($tWorker)
    $mPostProcessed = $tWorker.GetMethod('PostProcessed', $hereFlags, $null, @([string]), $null)

    $asm      = [System.Reflection.Assembly]::LoadFrom($dllPath)
    $tGrammar = $asm.GetType('FrenchGrammarPlus.FrenchGrammar')
    $tLexicon = $asm.GetType('FrenchGrammarPlus.Lexicon')
    $tMod     = $asm.GetType('FrenchGrammarPlus.FrenchGrammarPlusMod')
    $tSettings = $asm.GetType('FrenchGrammarPlus.Settings')

    # The mod reads its settings off a static property the Mod constructor fills. There is no Mod
    # instance here, so the backing field is set directly - the rules then run against real
    # settings objects, one per test, rather than against a stub.
    $settings = [Activator]::CreateInstance($tSettings)
    $tMod.GetField('<Settings>k__BackingField', $anyFlags).SetValue($null, $settings)
}

$haveCode = $null -ne $asm -and $null -ne $mPostProcessed
function NeedCode { if (-not $haveCode) { "the mod assembly or Assembly-CSharp is missing: $dllPath / $csPath" } }

# ---------------------------------------------------------------------------------------------
# The word lists, read once
# ---------------------------------------------------------------------------------------------

function Read-DataLines([string]$name) {
    $p = Join-Path $modDir "Data\$name"
    if (-not (Test-Path $p)) { return @() }
    return @(Get-Content $p -Encoding UTF8 |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_.Length -gt 0 -and $_[0] -ne '#' })
}

$aspiratedLines = Read-DataLines 'aspirated-h.txt'
$genderLines    = Read-DataLines 'pawnkind-gender.txt'

$genders = @{}
foreach ($line in $genderLines) {
    $eq = $line.IndexOf('=')
    if ($eq -le 0) { continue }
    $genders[$line.Substring(0, $eq).Trim()] = $line.Substring($eq + 1).Trim().ToLowerInvariant()
}

# The lexicon is filled from the real files, so the grammar tests below run against the list the
# mod ships rather than against a fixture.
if ($haveCode) {
    $prefixes = $tLexicon.GetField('AspiratedPrefixes', $anyFlags).GetValue($null)
    $prefixes.Clear()
    foreach ($w in $aspiratedLines) { $prefixes.Add($w.ToLowerInvariant()) | Out-Null }
    # Longest first, as Lexicon.Load does: a short prefix must not win over a longer one.
    $sorted = @($aspiratedLines | Sort-Object -Property Length -Descending)
    $prefixes.Clear()
    foreach ($w in $sorted) { $prefixes.Add($w.ToLowerInvariant()) | Out-Null }
}

# ---------------------------------------------------------------------------------------------
# Running the rules the way Harmony would
# ---------------------------------------------------------------------------------------------

function Reset-Settings {
    $settings.fixRichTextElision = $true
    $settings.fixAspiratedH      = $true
    $settings.fixPossessive      = $true
    $settings.fixPawnKindGender  = $true
    $settings.frenchTypography   = $false
    $settings.verboseLogging     = $false
}

# What the engine does on its own.
function Vanilla([string]$s) { return [string]$mPostProcessed.Invoke($worker, @([object]$s)) }

# What it does with the mod's prefix and postfix around it. This is the sandwich Harmony builds.
function Corrected([string]$s) {
    $shield = $tGrammar.GetMethod('Shield', $anyFlags)
    $apply  = $tGrammar.GetMethod('Apply',  $anyFlags)
    $a = [string]$shield.Invoke($null, @([object]$s))
    $b = Vanilla $a
    return [string]$apply.Invoke($null, @([object]$b))
}

$Guard = [string][char]0x200B

Write-Output "French Grammar Plus - test suite"
Write-Output "  mod       $ModRoot"
Write-Output "  game data $GameData"
if (-not $haveCode) { Write-Output "  NOTE: code tests will be skipped, an assembly is missing" }

# =============================================================================================
Section 'The grammar, run against the game''s own French rules'
# =============================================================================================

It 'the aspirated h keeps its article, where vanilla elides it' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    # left: what goes in.  middle: what vanilla alone must still get wrong.  right: the fix.
    $cases = @(
        @('de hache',        "d'hache",        'de hache'),
        @('de haricot',      "d'haricot",      'de haricot'),
        @('le haricot',      "l'haricot",      'le haricot'),
        @('la hache',        "l'hache",        'la hache'),
        @('de houblon',      "d'houblon",      'de houblon'),
        @('de husky',        "d'husky",        'de husky'),
        @('de \u0068autes herbes', "d'hautes herbes", 'de hautes herbes')
    )
    foreach ($c in $cases) {
        $in = Fr $c[0]; $wantVanilla = Fr $c[1]; $wantMod = Fr $c[2]
        $gotVanilla = Vanilla $in
        $gotMod     = Corrected $in
        if ($gotVanilla -cne $wantVanilla) {
            "vanilla no longer does this to '$in': expected '$wantVanilla', got '$gotVanilla' - the correction may be redundant now"
        }
        if ($gotMod -cne $wantMod) { "'$in' -> '$gotMod', expected '$wantMod'" }
    }
}

It 'a mute h still elides, exactly as without the mod' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    # The dangerous direction: over-matching would break text the game already gets right.
    $words = @('herbe', 'homme', 'heure', 'histoire', 'h\u00F4pital', 'hiver', 'huile',
               'honneur', 'h\u00E9ro\u00EFne', 'humain', 'hyperfibre', 'hydrog\u00E8ne')
    foreach ($w in $words) {
        foreach ($frame in @('de {0}', 'le {0}', 'la {0}')) {
            $in = Fr ($frame -f $w)
            $v  = Vanilla $in
            $m  = Corrected $in
            if ($m -cne $v) { "'$in': the mod changed vanilla's '$v' into '$m'" }
        }
    }
}

It 'the possessive takes son before a vowel, and leaves an aspirated h alone' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    $cases = @(
        @('sa \u00E9p\u00E9e',   'son \u00E9p\u00E9e'),
        @('ma arme',             'mon arme'),
        @('ta armure',           'ton armure'),
        @('sa hache',            'sa hache'),
        @('sa herbe',            'son herbe'),
        @('sa table',            'sa table')
    )
    foreach ($c in $cases) {
        $in = Fr $c[0]; $want = Fr $c[1]
        $got = Corrected $in
        if ($got -cne $want) { "'$in' -> '$got', expected '$want'" }
    }
    # And the rule is the mod's alone: vanilla must do none of it.
    $v = Vanilla (Fr 'sa \u00E9p\u00E9e')
    if ($v -cne (Fr 'sa \u00E9p\u00E9e')) { "vanilla now has a possessive rule of its own: 'sa epee' -> '$v'" }
}

It 'elision reaches across a rich text tag, where vanilla stops at it' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    $tag = '<color=#D09B61FF>'
    # The contraction cases carry their trailing space on purpose: the rule captures the
    # whitespace rather than assuming it, so that a newline is never swallowed.
    $cases = @(
        @("de ${tag}\u00C9clat</color>",      "d'${tag}\u00C9clat</color>"),
        @("la ${tag}\u00E9p\u00E9e</color>",  "l'${tag}\u00E9p\u00E9e</color>"),
        @("de ${tag}le mur</color> ",         "du ${tag}mur</color> "),
        @("de ${tag}les murs</color> ",       "des ${tag}murs</color> "),
        @("\u00E0 ${tag}le mur</color> ",     "au ${tag}mur</color> "),
        @("\u00E0 ${tag}les murs</color> ",   "aux ${tag}murs</color> ")
    )
    foreach ($c in $cases) {
        $in = Fr $c[0]; $want = Fr $c[1]
        $gotVanilla = Vanilla $in
        if ($gotVanilla -cne $in) { "vanilla now reaches across the tag itself: '$in' -> '$gotVanilla'" }
        $got = Corrected $in
        if ($got -cne $want) { "'$in' -> '$got', expected '$want'" }
    }
}

It 'the guard never survives into the output' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    foreach ($s in @('de hache', 'sa hache', 'le haricot et la hache', 'hache')) {
        $got = Corrected (Fr $s)
        if ($got.Contains($Guard)) { "'$s' -> output still carries the zero-width guard" }
    }
    # And with the correction off, the shield must not insert one either.
    $settings.fixAspiratedH = $false
    $got = Corrected 'de hache'
    if ($got.Contains($Guard)) { 'a guard was inserted with the aspirated-h correction switched off' }
}

It 'typography is off by default, and spaces only what ends a clause' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    $fresh = [Activator]::CreateInstance($tSettings)
    if ($fresh.frenchTypography) { 'frenchTypography ships on; it must default to off' }

    $nbsp  = [string][char]0x00A0
    $nnbsp = [string][char]0x202F

    # Vanilla inserts none of these itself, checked here rather than assumed: if it ever starts,
    # this correction becomes redundant and the comparison below is what says so.
    $plain = Fr 'affam\u00E9s :'
    if ((Vanilla $plain) -cne $plain) { 'vanilla now spaces its own punctuation; this correction may be redundant' }
    if ((Corrected $plain) -cne $plain) { 'typography acted while switched off' }

    $settings.frenchTypography = $true
    $cases = @(
        @('Ces colons sont affam\u00E9s :', "Ces colons sont affam\u00E9s${nbsp}:"),
        @('Langue : x',                     "Langue${nbsp}: x"),
        @('Vraiment ?',                     "Vraiment${nnbsp}?"),
        @('Attention !',                    "Attention${nnbsp}!"),
        @('un ; deux',                      "un${nnbsp}; deux")
    )
    foreach ($c in $cases) {
        $in = Fr $c[0]; $want = Fr $c[1]
        $got = Corrected $in
        if ($got -cne $want) { "'$in' -> '$got', expected '$want'" }
    }
    # The two things it must never touch, and the reason the colon rule is written as it is.
    foreach ($s in @('il est 12:00 ici', 'voir http://example.com ici')) {
        $got = Corrected $s
        if ($got -cne $s) { "'$s' -> '$got'; a clock or a URL must be left alone" }
    }
    # An existing space is absorbed, never doubled.
    $got = Corrected (Fr "d\u00E9j\u00E0${nbsp}:")
    if ($got -cne (Fr "d\u00E9j\u00E0${nbsp}:")) { "an existing no-break space was doubled: '$got'" }
}

It 'each switch turns off its own correction and no other' {
    $skip = NeedCode; if ($skip) { $skip; return }
    # One probe per correction, chosen so the other corrections cannot touch it.
    $probes = @(
        @{ flag = 'fixAspiratedH';      input = 'de hache';                       on = 'de hache';                        off = "d'hache" },
        @{ flag = 'fixPossessive';      input = 'sa \u00E9p\u00E9e';              on = 'son \u00E9p\u00E9e';              off = 'sa \u00E9p\u00E9e' },
        @{ flag = 'fixRichTextElision'; input = 'de <b>\u00C9clat</b>';           on = "d'<b>\u00C9clat</b>";             off = 'de <b>\u00C9clat</b>' }
    )
    foreach ($p in $probes) {
        Reset-Settings
        $got = Corrected (Fr $p.input)
        if ($got -cne (Fr $p.on)) { "$($p.flag) on: '$(Fr $p.input)' -> '$got', expected '$(Fr $p.on)'" }

        $settings.($p.flag) = $false
        $got = Corrected (Fr $p.input)
        if ($got -cne (Fr $p.off)) { "$($p.flag) off: '$(Fr $p.input)' -> '$got', expected '$(Fr $p.off)'" }

        # With only this one off, every other probe must be unaffected.
        foreach ($q in $probes) {
            if ($q.flag -eq $p.flag) { continue }
            $g = Corrected (Fr $q.input)
            if ($g -cne (Fr $q.on)) { "$($p.flag) off also silenced $($q.flag): '$(Fr $q.input)' -> '$g'" }
        }
    }
    Reset-Settings
}

It 'the definite article is rebuilt for an aspirated h, and only for one' {
    $skip = NeedCode; if ($skip) { $skip; return }
    Reset-Settings
    $m = $tGrammar.GetMethod('FixDefiniteArticle', $anyFlags)
    if ($null -eq $m) { 'FrenchGrammar.FixDefiniteArticle is gone'; return }
    $tGender = $csharp.GetType('Verse.Gender')
    $male   = [Enum]::Parse($tGender, 'Male')
    $female = [Enum]::Parse($tGender, 'Female')

    $cases = @(
        @("l'husky",   $male,   'le husky'),
        @("l'hache",   $female, 'la hache'),
        @("L'hache",   $female, 'La hache'),
        @("l'herbe",   $female, "l'herbe"),
        @("l'humain",  $male,   "l'humain"),
        @('le husky',  $male,   'le husky')
    )
    foreach ($c in $cases) {
        $args = [object[]]@((Fr $c[0]), $c[1])
        $m.Invoke($null, $args) | Out-Null
        $got = [string]$args[0]
        if ($got -cne (Fr $c[2])) { "'$(Fr $c[0])' ($($c[1])) -> '$got', expected '$(Fr $c[2])'" }
    }
}

# =============================================================================================
Section 'The patch targets, and the names Harmony matches by'
# =============================================================================================

It 'PostProcessed is declared on the French worker itself, with a parameter named str' {
    $skip = NeedCode; if ($skip) { $skip; return }
    if ($null -eq $mPostProcessed) {
        'LanguageWorker_French does not declare PostProcessed(string); the mod would patch nothing'
        return
    }
    $p = $mPostProcessed.GetParameters()
    if ($p.Count -ne 1 -or $p[0].Name -cne 'str') {
        "PostProcessed's parameter is named '$($p[0].Name)', not 'str'; Harmony matches by name"
    }
}

It 'WithDefiniteArticle is declared there too, with a parameter named gender' {
    $skip = NeedCode; if ($skip) { $skip; return }
    $m = $tWorker.GetMethod('WithDefiniteArticle', $hereFlags)
    if ($null -eq $m) { 'LanguageWorker_French does not declare WithDefiniteArticle'; return }
    if (-not ($m.GetParameters() | Where-Object { $_.Name -ceq 'gender' })) {
        "WithDefiniteArticle has no parameter named 'gender': $(($m.GetParameters() | ForEach-Object { $_.Name }) -join ', ')"
    }
}

It 'exactly one RulesForPawn takes a PawnKindDef, and names pawnSymbol and kind' {
    $skip = NeedCode; if ($skip) { $skip; return }
    # Verse.Grammar, not Verse; and PawnKindDef is in Verse, not RimWorld. The mod's own file
    # imports both namespaces, so the C# never has to say which - this does.
    $tGU   = $csharp.GetType('Verse.Grammar.GrammarUtility')
    $tKind = $csharp.GetType('Verse.PawnKindDef')
    if ($null -eq $tGU -or $null -eq $tKind) { 'GrammarUtility or PawnKindDef is gone'; return }

    $matches = @($tGU.GetMethods($hereFlags) | Where-Object {
        $_.Name -ceq 'RulesForPawn' -and ($_.GetParameters() | Where-Object { $_.ParameterType -eq $tKind })
    })
    if ($matches.Count -ne 1) {
        "$($matches.Count) overloads of RulesForPawn take a PawnKindDef; the mod resolves by shape and expects one"
        return
    }
    $names = @($matches[0].GetParameters() | ForEach-Object { $_.Name })
    foreach ($n in @('pawnSymbol', 'kind')) {
        if ($names -cnotcontains $n) { "RulesForPawn has no parameter named '$n': $($names -join ', ')" }
    }
}

It 'the mod''s patch methods use the argument names Harmony needs' {
    $skip = NeedCode; if ($skip) { $skip; return }
    $expected = @{
        'FrenchGrammarPlus.PostProcessedPatch|Prefix'   = @('str')
        'FrenchGrammarPlus.PostProcessedPatch|Postfix'  = @('__result')
        'FrenchGrammarPlus.DefiniteArticlePatch|Postfix' = @('__result', 'gender')
        'FrenchGrammarPlus.RulesForPawnPatch|Postfix'   = @('values', 'pawnSymbol', 'kind')
    }
    foreach ($key in $expected.Keys) {
        $parts = $key.Split('|')
        $t = $asm.GetType($parts[0])
        if ($null -eq $t) { "type $($parts[0]) is gone"; continue }
        $m = $t.GetMethod($parts[1], $anyFlags)
        if ($null -eq $m) { "$($parts[0]).$($parts[1]) is gone"; continue }
        $names = @($m.GetParameters() | ForEach-Object { $_.Name })
        foreach ($n in $expected[$key]) {
            if ($names -cnotcontains $n) { "$($parts[0]).$($parts[1]) has no '$n': $($names -join ', ')" }
        }
    }
}

# =============================================================================================
Section 'The word lists, against the defs the game ships'
# =============================================================================================

It 'aspirated-h.txt is lowercase, unique and non-empty' {
    if ($aspiratedLines.Count -eq 0) { 'aspirated-h.txt is missing or empty'; return }
    $seen = @{}
    foreach ($w in $aspiratedLines) {
        if ($w -cne $w.ToLowerInvariant()) { "'$w' is not lowercase; matching lowercases the text, so it would never fire" }
        if ($w -match '\s')                { "'$w' contains a space; entries are single words" }
        if ($seen.ContainsKey($w))         { "'$w' is listed twice" }
        $seen[$w] = $true
    }
}

It 'no aspirated prefix catches a word with a mute h' {
    # The one mistake that would break text the game already gets right, everywhere, in silence.
    $mute = @('homme', 'heure', 'histoire', 'hopital', 'herbe', 'hiver', 'huile', 'honneur',
              'heroine', 'hebergement', 'humain', 'hyperfibre', 'hydrogene', 'hectare',
              'heritage', 'hesitation', 'horaire', 'hotel', 'huitre', 'hymne')
    foreach ($w in $mute) {
        foreach ($p in $aspiratedLines) {
            if ($w.StartsWith($p, [StringComparison]::Ordinal)) {
                "'$p' catches '$w', which takes a mute h and must elide"
            }
        }
    }
}

It 'pawnkind-gender.txt parses, every line, with no duplicate' {
    if ($genderLines.Count -eq 0) { 'pawnkind-gender.txt is missing or empty'; return }
    $seen = @{}
    foreach ($line in $genderLines) {
        $eq = $line.IndexOf('=')
        if ($eq -le 0 -or $eq -eq $line.Length - 1) { "'$line' is not defName=f|m"; continue }
        $name  = $line.Substring(0, $eq).Trim()
        $value = $line.Substring($eq + 1).Trim().ToLowerInvariant()
        if ($value -notin @('f', 'm', 'female', 'male')) { "'$line' has gender '$value'" }
        if ($seen.ContainsKey($name)) { "'$name' is listed twice" }
        $seen[$name] = $true
    }
}

# The animals the game ships. Their PawnKindDefs live in the race files, not under Defs/PawnKinds,
# and each carries the defName of its race - which is the key the mod looks up.
$gameKinds = @{}
foreach ($f in @(Get-ChildItem $GameData -Recurse -Filter 'Races_Animal*.xml' -ErrorAction SilentlyContinue)) {
    try {
        $x = New-Object System.Xml.XmlDocument
        $x.Load($f.FullName)
        foreach ($n in $x.SelectNodes('//PawnKindDef/defName')) { $gameKinds[$n.InnerText] = $true }
    } catch { }
}

It 'every listed species is a pawn kind the game actually ships' {
    if ($gameKinds.Count -eq 0) { "no animal pawn kinds found under $GameData"; return }
    foreach ($name in $genders.Keys) {
        if (-not $gameKinds.ContainsKey($name)) { "'$name' is not a PawnKindDef in this installation" }
    }
}

It 'every animal the game ships has a gender' {
    if ($gameKinds.Count -eq 0) { "no animal pawn kinds found under $GameData"; return }
    foreach ($name in $gameKinds.Keys) {
        if (-not $genders.ContainsKey($name)) { "'$name' ships with the game and has no entry" }
    }
}

It 'the file''s header counts match the file' {
    $p = Join-Path $modDir 'Data\pawnkind-gender.txt'
    if (-not (Test-Path $p)) { 'pawnkind-gender.txt is missing'; return }
    # The comment marks have to come off before joining, or a sentence that wraps across two
    # lines gets a '#' dropped into the middle of it and no pattern will ever match.
    $header = (Get-Content $p -Encoding UTF8 |
        Where-Object { $_.TrimStart().StartsWith('#') } |
        ForEach-Object { $_.TrimStart().TrimStart('#').Trim() }) -join ' '
    $m = [regex]::Match($header, '(\d+)\s+entries,\s+(\d+)\s+feminine\s+and\s+(\d+)\s+masculine')
    if (-not $m.Success) { 'the header no longer states its counts, so nothing keeps them honest'; return }

    $f = @($genders.Values | Where-Object { $_ -in @('f', 'female') }).Count
    $mm = @($genders.Values | Where-Object { $_ -in @('m', 'male') }).Count
    if ([int]$m.Groups[1].Value -ne $genders.Count) { "the header says $($m.Groups[1].Value) entries, the file has $($genders.Count)" }
    if ([int]$m.Groups[2].Value -ne $f)  { "the header says $($m.Groups[2].Value) feminine, the file has $f" }
    if ([int]$m.Groups[3].Value -ne $mm) { "the header says $($m.Groups[3].Value) masculine, the file has $mm" }
}

# =============================================================================================
Section 'Translations'
# =============================================================================================

$sourceText = ''
foreach ($f in @(Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Filter *.cs -ErrorAction SilentlyContinue)) {
    $sourceText += (Get-Content $f.FullName -Raw) + "`n"
}
$askedKeys = @([regex]::Matches($sourceText, '"(FGP\.[A-Za-z.]+)"\.Translate\(') |
    ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)

function Read-Keys([string]$language) {
    $p = Join-Path $modDir "Languages\$language\Keyed\FrenchGrammarPlus.xml"
    if (-not (Test-Path $p)) { return $null }
    $x = New-Object System.Xml.XmlDocument
    $x.Load($p)
    return @($x.LanguageData.ChildNodes | Where-Object { $_.NodeType -eq 'Element' } | ForEach-Object { $_.Name })
}

$englishKeys = Read-Keys 'English'
$frenchKeys  = Read-Keys 'French'

It 'every key the C# asks for exists in English' {
    if ($askedKeys.Count -eq 0) { 'no FGP.* key found in the source; the scan is broken'; return }
    if ($null -eq $englishKeys) { 'the English Keyed file is missing'; return }
    foreach ($k in $askedKeys) {
        if ($englishKeys -cnotcontains $k) { "'$k' is asked for in the C# and absent from English" }
    }
}

It 'French matches English key for key' {
    if ($null -eq $englishKeys -or $null -eq $frenchKeys) { 'a Keyed file is missing'; return }
    foreach ($k in $englishKeys) { if ($frenchKeys -cnotcontains $k) { "'$k' is in English and not in French" } }
    foreach ($k in $frenchKeys)  { if ($englishKeys -cnotcontains $k) { "'$k' is in French and not in English" } }
}

It 'no key is shipped that nothing asks for' {
    if ($null -eq $englishKeys) { 'the English Keyed file is missing'; return }
    foreach ($k in $englishKeys) {
        if ($askedKeys -cnotcontains $k) { "'$k' is translated and never used" }
    }
}

# =============================================================================================
Section 'What ships, and what sits beside it'
# =============================================================================================

$aboutPath = Join-Path $modDir 'About\About.xml'
$about = $null
if (Test-Path $aboutPath) { $about = New-Object System.Xml.XmlDocument; $about.Load($aboutPath) }

It 'the About''s packageId is the one the C# hard-codes' {
    if ($null -eq $about) { 'About.xml is missing'; return }
    $inXml = [string]$about.ModMetaData.packageId
    $m = [regex]::Match($sourceText, 'PackageId\s*=\s*"([^"]+)"')
    if (-not $m.Success) { 'no PackageId constant found in the source'; return }
    if ($inXml -cne $m.Groups[1].Value) {
        "About.xml says '$inXml', the C# says '$($m.Groups[1].Value)'"
    }
}

It 'the folder Steam receives carries nothing but the mod' {
    # The uploader sends Mod/ whole, with no exclusion possible.
    $strays = @()
    foreach ($name in @('STATUS.md', 'TESTING.md', 'README.md', 'CHANGELOG.md', '.gitignore')) {
        if (Test-Path (Join-Path $modDir $name)) { $strays += $name }
    }
    foreach ($d in @('obj', 'bin', 'Source', '_tools', 'Art')) {
        if (Test-Path (Join-Path $modDir $d)) { $strays += "$d/" }
    }
    foreach ($s in $strays) { "Mod/$s would be published to the Workshop" }

    # ATTRIBUTION.md and LICENSE are deliberately duplicated into Mod/; their absence is the fault.
    foreach ($name in @('ATTRIBUTION.md', 'LICENSE')) {
        if (-not (Test-Path (Join-Path $modDir $name))) { "Mod/$name is missing; the published folder must carry its own copy" }
    }
}

It 'the C# sources are pure ASCII' {
    foreach ($f in @(Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Filter *.cs -ErrorAction SilentlyContinue)) {
        $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
        $bad = @($bytes | Where-Object { $_ -gt 127 })
        if ($bad.Count -gt 0) {
            "$($f.Name) has $($bad.Count) non-ASCII bytes; accents belong in \u escapes so no codepage can mangle them"
        }
    }
}

It 'the status sheet''s field names are the English ones' {
    # A sweep across the repository once translated these keys and left the prose behind, and a
    # sheet half in each language is far harder to spot than an empty one. Hunting French words
    # in the prose is hopeless here of all places - this is a French mod and its documents quote
    # French on purpose - so what is checked is the field names, which have exactly one spelling.
    $p = Join-Path $ModRoot 'STATUS.md'
    if (-not (Test-Path $p)) { 'STATUS.md is missing'; return }
    $old = @{
        'depot:' = 'repo:'; 'visibilite:' = 'visibility:'; 'detache:' = 'detached:'
        'etape:' = 'stage:'; 'vitrine:' = 'showcase:'; 'teste_le:' = 'tested_on:'
        'reste:' = 'remaining:'; 'maj:' = 'updated:'; 'licence_ou:' = 'licence_at:'
    }
    $lines = @(Get-Content $p -Encoding UTF8)
    foreach ($key in $old.Keys) {
        foreach ($line in $lines) {
            if ($line.TrimStart().StartsWith($key)) { "'$key' is the French field name; it is '$($old[$key])'" }
        }
    }
}

It 'the status sheet has a closed front matter with its session and date' {
    $p = Join-Path $ModRoot 'STATUS.md'
    if (-not (Test-Path $p)) { 'STATUS.md is missing'; return }
    $lines = @(Get-Content $p -Encoding UTF8)
    $fences = @($lines | Where-Object { $_ -ceq '---' }).Count
    if ($fences -lt 2) { "the front matter is not closed: $fences '---' lines. An unclosed one turns the sheet into prose and the next reader finds nothing" }
    foreach ($key in @('mod:', 'packageId:', 'stage:', 'licence:', 'session:', 'updated:')) {
        if (-not ($lines | Where-Object { $_.StartsWith($key) })) { "the front matter has no '$key'" }
    }
}

# =============================================================================================

. (Join-Path $PSScriptRoot 'Settings-Tests.ps1')

Write-Output ''
if ($script:failed -eq 0) {
    Write-Output "$($script:ran) tests, all passing."
} else {
    Write-Output "$($script:ran) tests, $($script:failed) failing."
}

[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)
exit ([int]($script:failed -gt 0))
