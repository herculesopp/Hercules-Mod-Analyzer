[CmdletBinding()]
param(
    [string]$Path,
    [switch]$SkipRuntimeScan,
    [switch]$SkipMemoryScan,
    [ValidateRange(32, 1024)]
    [int]$MemoryScanMB = 192,
    [switch]$NoModVerification,
    [switch]$NoMegabase,
    [switch]$RevealHidden,
    [switch]$NoStatusLists,
    [switch]$ShowStatusLists,
    [switch]$Quiet
)

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

$script:Config = @{
    Name = "Hercules Mod Analyzer"
    Version = "2.0.13"
    Creator = "Hercules"
    Credits = @(
        [pscustomobject]@{
            Name = "MeowTonynoh"
            Project = "Meow Mod Analyzer"
            Url = "https://github.com/MeowTonynoh"
        },
        [pscustomobject]@{
            Name = "YarpLetapStan"
            Project = "Yarp's Mod Analyzer"
            Url = "https://github.com/YarpLetapStan/PowershellScripts"
        },
        [pscustomobject]@{
            Name = "veridondevvv"
            Project = "Yumiko Mod Analyzer"
            Url = "https://github.com/veridondevvv/YumikoModAnalyzer"
        }
    )
    ModCheatTokens = @(
        "hellion",
        "fastxp",
        "noclip",
        "itemexploit",
        "freezeplayer",
        "exploit",
        "aimassist",
        "dqrkis",
        "clientplayerinteractionmanageraccessor",
        "anchor macro",
        "doubleanchor",
        "autototem",
        "speed",
        "obfuscatedauth",
        "packspoof",
        "esp",
        "scaffold",
        "cracked",
        "gypsy",
        "killaura",
        "aim assist",
        "elytraswap",
        "cracked client",
        "legittotem",
        "axespam",
        "silentaim",
        "licensecheckmixin",
        "spearswap",
        "autodoublehand",
        "lagreach",
        "org.chainlibs.module.impl.modules.blatant",
        "airanchor",
        "autoarmor",
        "inventorytotem",
        "dev.gambleclient",
        "invsee",
        "jumpreset",
        "clientplayerentitymixim",
        "pingspoof",
        "fastexp",
        "silent rotations",
        "auto crystal",
        "maceswap",
        "autocrystal",
        "webmacro",
        "nojumpdelay",
        "authbypass",
        "fly",
        "automine",
        "autoanchor",
        "lootyeeter",
        "shielddisabler",
        "self destruct",
        "walskyoptimizer",
        "keypearl",
        "basefinder",
        "dev.krypton",
        "xray",
        "velocity",
        "walksycrystaloptimizermod",
        "shieldbreaker",
        "jnativehook",
        "auto totem",
        "automace",
        "bypass",
        "antiknockback",
        "anchortweaks",
        "ghost client",
        "reach",
        "catlean",
        "org.chainlibs.module.impl.modules.crystal",
        "autoeat",
        "autohitcrystal",
        "freecam",
        "xenon",
        "hovertotem",
        "argon",
        "autopot",
        "autobreach",
        "fakeinv",
        "autofirework",
        "fakelag",
        "safeanchor",
        "autoclicker",
        "walksyoptimizer",
        "phantom-refmap",
        "triggerbot",
        "selfdestruct"
    )
    TokenWeights = @{
        "ghost client" = 4
        freezeplayer = 2
        "self destruct" = 3
        autototem = 3
        fastxp = 2
        fakeinv = 2
        jnativehook = 3
        "anchor macro" = 2
        xenon = 3
        aimassist = 3
        fastexp = 2
        spearswap = 2
        walskyoptimizer = 4
        automace = 2
        inventorytotem = 3
        webmacro = 2
        nojumpdelay = 2
        selfdestruct = 3
        "aim assist" = 3
        reach = 2
        shielddisabler = 3
        maceswap = 2
        doubleanchor = 2
        autoarmor = 2
        fly = 2
        "auto totem" = 3
        shieldbreaker = 3
        speed = 1
        scaffold = 2
        freecam = 2
        "org.chainlibs.module.impl.modules.blatant" = 4
        exploit = 3
        legittotem = 2
        antiknockback = 2
        autoclicker = 3
        walksycrystaloptimizermod = 4
        axespam = 2
        authbypass = 4
        autofirework = 2
        silentaim = 3
        safeanchor = 2
        lootyeeter = 2
        hellion = 3
        "org.chainlibs.module.impl.modules.crystal" = 4
        noclip = 2
        autobreach = 2
        esp = 2
        walksyoptimizer = 4
        packspoof = 2
        obfuscatedauth = 4
        killaura = 3
        fakelag = 2
        elytraswap = 2
        autocrystal = 3
        itemexploit = 3
        catlean = 3
        "dev.krypton" = 4
        jumpreset = 2
        velocity = 1
        xray = 3
        triggerbot = 3
        "auto crystal" = 2
        basefinder = 2
        bypass = 3
        argon = 3
        autopot = 2
        hovertotem = 3
        "cracked client" = 4
        autohitcrystal = 3
        "dev.gambleclient" = 4
        autoanchor = 3
        licensecheckmixin = 4
        gypsy = 3
        dqrkis = 4
        lagreach = 2
        pingspoof = 2
        "phantom-refmap" = 3
        cracked = 2
    }
    CriticalCheatTokens = @(
        "xenon",
        "dqrkis",
        "org.chainlibs.module.impl.modules.crystal",
        "walksycrystaloptimizermod",
        "org.chainlibs.module.impl.modules.blatant",
        "ghost client",
        "walksyoptimizer",
        "obfuscatedauth",
        "cracked client",
        "walskyoptimizer",
        "licensecheckmixin",
        "gypsy",
        "dev.gambleclient",
        "hellion",
        "dev.krypton",
        "authbypass",
        "catlean"
    )
    CheatSignatureStrings = @(
        "MemoryModuleHelper",
        "AutoCrystal",
        "FakeInv",
        "VIEW_LABEL_MODULES",
        "InventoryTotem",
        "VIEW_ICON_MODULES",
        "moduleToggleAnim",
        "ShieldDisabler",
        "modulesButton",
        "AutoAnchor",
        "HoverTotem",
        "ModuleRegistry",
        "Anchor Macro",
        "PingSpoof",
        "Dqrkis Client (Cracked)",
        "modulePreview",
        "selectedModule",
        "Automatically attacks while falling with mace.",
        "renderModuleList",
        "A.utomatically hit-crystals for you",
        "ModModule",
        "TriggerBot"
    )
    HighConfidenceSignatureStrings = @(
        "VIEW_ICON_MODULES",
        "A.utomatically hit-crystals for you",
        "Automatically attacks while falling with mace.",
        "moduleToggleAnim",
        "MemoryModuleHelper",
        "ModuleRegistry",
        "Dqrkis Client (Cracked)",
        "VIEW_LABEL_MODULES",
        "ModModule"
    )
    MemoryFilterStrings = @(
        "assets/minecraft/optifine/cit/profile/prestige/",
        "*.prestigeclient.vip0",
        ".psaclient",
        "AutoInventoryTotem",
        "DoomsdayClient:::bot),%.R",
        "prestigeclient.vip",
        "DoomsdayClient:::eObOiPdFJR 2",
        "Auto Crystal",
        "Auto Mace",
        "legit totem",
        "Anchor Macro",
        ".prestigeclient.vip0",
        "prestige_4.properties",
        "DoomsdayClient:::Wu&XNC]30?3=7",
        "Doomsday",
        "Auto Dtap",
        "CrystalAura",
        "Aimbot",
        "fastplace",
        "autocrystal",
        "DoomsdayClient",
        "198m",
        "LegitRetotem",
        "AnchorAura",
        "DoomsdayClient:::u;<r,7NVce;Ga25",
        "Auto Hit Crystal",
        "Auto Shield Disabler",
        "prestigeclient.vip0Y0",
        "Self Destruct",
        "prestige"
    )
    RuntimeInjectionPatterns = @(
        [pscustomobject]@{ Label = "Java agent injection"; Pattern = "(?i)-javaagent:" },
        [pscustomobject]@{ Label = "Native agent injection"; Pattern = "(?i)-agentpath:" },
        [pscustomobject]@{ Label = "Agent library injection"; Pattern = "(?i)-agentlib:" },
        [pscustomobject]@{ Label = "Boot classpath injection"; Pattern = "(?i)-Xbootclasspath" },
        [pscustomobject]@{ Label = "Fabric addMods injection"; Pattern = "(?i)-Dfabric\.addMods=" },
        [pscustomobject]@{ Label = "Fabric loadMods injection"; Pattern = "(?i)-Dfabric\.loadMods=" },
        [pscustomobject]@{ Label = "Fabric classPathGroups injection"; Pattern = "(?i)-Dfabric\.classPathGroups=" },
        [pscustomobject]@{ Label = "Fabric gameJarPath override"; Pattern = "(?i)-Dfabric\.gameJarPath=" },
        [pscustomobject]@{ Label = "Fabric skipMcProvider override"; Pattern = "(?i)-Dfabric\.skipMcProvider=" },
        [pscustomobject]@{ Label = "Fabric development override"; Pattern = "(?i)-Dfabric\.development=" },
        [pscustomobject]@{ Label = "Fabric unsupported version override"; Pattern = "(?i)-Dfabric\.allowUnsupportedVersion=" },
        [pscustomobject]@{ Label = "Fabric remapClasspathFile injection"; Pattern = "(?i)-Dfabric\.remapClasspathFile=" },
        [pscustomobject]@{ Label = "Fabric skipIntermediary override"; Pattern = "(?i)-Dfabric\.skipIntermediary=" },
        [pscustomobject]@{ Label = "Fabric configDir override"; Pattern = "(?i)-Dfabric\.configDir=" },
        [pscustomobject]@{ Label = "Fabric loader config override"; Pattern = "(?i)-Dfabric\.loader\.config=" },
        [pscustomobject]@{ Label = "Fabric log level override"; Pattern = "(?i)-Dfabric\.log\.level=" },
        [pscustomobject]@{ Label = "Fabric debug classpath dump"; Pattern = "(?i)-Dfabric\.debug\.dumpClasspath=" },
        [pscustomobject]@{ Label = "Fabric log config override"; Pattern = "(?i)-Dfabric\.log\.config=" },
        [pscustomobject]@{ Label = "Fabric DLI config override"; Pattern = "(?i)-Dfabric\.dli\.config=" },
        [pscustomobject]@{ Label = "Fabric mixin configs injection"; Pattern = "(?i)-Dfabric\.mixin\.configs=" },
        [pscustomobject]@{ Label = "Fabric mixin hotSwap override"; Pattern = "(?i)-Dfabric\.mixin\.hotSwap=" },
        [pscustomobject]@{ Label = "Fabric mixin debug export"; Pattern = "(?i)-Dfabric\.mixin\.debug\.export=" },
        [pscustomobject]@{ Label = "Fabric mixin verbose debug"; Pattern = "(?i)-Dfabric\.mixin\.debug\.verbose=" },
        [pscustomobject]@{ Label = "Fabric gameVersion override"; Pattern = "(?i)-Dfabric\.gameVersion=" },
        [pscustomobject]@{ Label = "Fabric forceVersion override"; Pattern = "(?i)-Dfabric\.forceVersion=" },
        [pscustomobject]@{ Label = "Fabric autoDetectVersion override"; Pattern = "(?i)-Dfabric\.autoDetectVersion=" },
        [pscustomobject]@{ Label = "Fabric launcher name override"; Pattern = "(?i)-Dfabric\.launcher\.name=" },
        [pscustomobject]@{ Label = "Fabric launcher brand override"; Pattern = "(?i)-Dfabric\.launcher\.brand=" },
        [pscustomobject]@{ Label = "Fabric mods.toml path override"; Pattern = "(?i)-Dfabric\.mods\.toml\.path=" },
        [pscustomobject]@{ Label = "Fabric custom mod list injection"; Pattern = "(?i)-Dfabric\.customModList=" },
        [pscustomobject]@{ Label = "Fabric resolve modFiles override"; Pattern = "(?i)-Dfabric\.resolve\.modFiles=" },
        [pscustomobject]@{ Label = "Fabric skip dependency resolution"; Pattern = "(?i)-Dfabric\.skipDependencyResolution=" },
        [pscustomobject]@{ Label = "Fabric loader entrypoints injection"; Pattern = "(?i)-Dfabric\.loader\.entrypoints=" },
        [pscustomobject]@{ Label = "Fabric language providers injection"; Pattern = "(?i)-Dfabric\.language\.providers=" },
        [pscustomobject]@{ Label = "Forge addMods injection"; Pattern = "(?i)-Dforge\.addMods=" },
        [pscustomobject]@{ Label = "Forge mods override"; Pattern = "(?i)-Dforge\.mods=" },
        [pscustomobject]@{ Label = "Forge coremod load injection"; Pattern = "(?i)-Dfml\.coreMods\.load=" },
        [pscustomobject]@{ Label = "Forge coreMods dir override"; Pattern = "(?i)-Dforge\.coreMods\.dir=" },
        [pscustomobject]@{ Label = "Forge modDir override"; Pattern = "(?i)-Dforge\.modDir=" },
        [pscustomobject]@{ Label = "Forge modsDirectories override"; Pattern = "(?i)-Dforge\.modsDirectories=" },
        [pscustomobject]@{ Label = "FML custom mod list injection"; Pattern = "(?i)-Dfml\.customModList=" },
        [pscustomobject]@{ Label = "Forge disable mod scan override"; Pattern = "(?i)-Dforge\.disableModScan=" },
        [pscustomobject]@{ Label = "Forge modList override"; Pattern = "(?i)-Dforge\.modList=" },
        [pscustomobject]@{ Label = "Forge forceVersion override"; Pattern = "(?i)-Dforge\.forceVersion=" },
        [pscustomobject]@{ Label = "Forge disable update check"; Pattern = "(?i)-Dforge\.disableUpdateCheck=" },
        [pscustomobject]@{ Label = "Forge Mojang logging override"; Pattern = "(?i)-Dforge\.logging\.mojang\.level=" },
        [pscustomobject]@{ Label = "Forge mixin hotSwap override"; Pattern = "(?i)-Dforge\.mixin\.hotSwap=" },
        [pscustomobject]@{ Label = "Forge resourcePack override"; Pattern = "(?i)-Dforge\.resourcePack=" },
        [pscustomobject]@{ Label = "Forge defaultResourcePack override"; Pattern = "(?i)-Dforge\.defaultResourcePack=" },
        [pscustomobject]@{ Label = "Forge texturePacks override"; Pattern = "(?i)-Dforge\.texturePacks=" },
        [pscustomobject]@{ Label = "Forge assetIndex override"; Pattern = "(?i)-Dforge\.assetIndex=" },
        [pscustomobject]@{ Label = "Forge assetsDir override"; Pattern = "(?i)-Dforge\.assetsDir=" },
        [pscustomobject]@{ Label = "System classloader override"; Pattern = "(?i)-Djava\.system\.class\.loader=" },
        [pscustomobject]@{ Label = "Class path override"; Pattern = "(?i)-Djava\.class\.path=" },
        [pscustomobject]@{ Label = "Encoded injection symbols"; Pattern = "(?i)(%3B|%26%26|%7C%7C|%7C|%60|%24|%3C|%3E)" }
    )
    LegitAgentHints = @(
        "intellij",
        "newrelic",
        "idea_rt",
        "lombok",
        "jrebel",
        "flightrecorder",
        "jfr",
        "jetbrains",
        "visualvm",
        "async-profiler",
        "theseus",
        "jacoco",
        "jmxremote",
        "yjp",
        "hprof",
        "byte-buddy"
    )
    LegitAgentPathHints = @(
        "\\projectlombok\\",
        "\\.gradle\\caches\\",
        "\\m2\\repository\\",
        "\\jetbrains\\",
        "\\intellij",
        "\\eclipse\\",
        "\\jdk\\",
        "\\java\\",
        "\\microsoft\\jdk\\",
        "\\temurin\\",
        "\\modrinthapp\\",
        "\\prismlauncher\\",
        "\\multimc\\",
        "\\lunarclient\\",
        "\\badlion\\",
        "\\curseforge\\",
        "\\.minecraft\\libraries\\"
    )
    SuspiciousAgentHints = @(
        "inject",
        "bypass",
        "cheat",
        "ghost",
        "clicker",
        "aim",
        "killaura",
        "triggerbot",
        "reach",
        "velocity",
        "xray",
        "selfdestruct",
        "dqrkis",
        "argon",
        "walksy",
        "walsky",
        "catlean",
        "xenon",
        "gypsy"
    )
    RuntimeHighRiskLabels = @(
        "Native agent injection",
        "Agent library injection",
        "Boot classpath injection",
        "Fabric addMods injection",
        "Fabric loadMods injection",
        "Fabric remapClasspathFile injection",
        "Fabric custom mod list injection",
        "Fabric resolve modFiles override",
        "Fabric loader entrypoints injection",
        "Fabric language providers injection",
        "Forge addMods injection",
        "Forge coremod load injection",
        "Forge coreMods dir override",
        "Forge modDir override",
        "Forge modsDirectories override",
        "FML custom mod list injection",
        "Forge modList override",
        "System classloader override",
        "Encoded injection symbols"
    )
    RuntimeEditGraceSeconds = 3
}

$script:ModTokenPatterns = @()
foreach ($token in $script:Config.ModCheatTokens) {
    $escaped = [regex]::Escape($token) -replace "\\ ", "[\\s_\\-]*"
    $pattern = "(?i)(?<![a-z0-9])$escaped(?![a-z0-9])"
    $script:ModTokenPatterns += [pscustomobject]@{
        Token = $token
        Regex = [regex]::new($pattern)
    }
}

$script:MemoryNeedlesNormalized = @(
    $script:Config.MemoryFilterStrings |
        ForEach-Object {
            $n = ([string]$_).Trim().ToLowerInvariant()
            if ($n.StartsWith("*")) { $n = $n.TrimStart("*") }
            if ($n.EndsWith("*")) { $n = $n.TrimEnd("*") }
            $n
        } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Select-Object -Unique
)

$script:SignatureMatchersCache = @()

$script:MemoryApiLoaded = $false
$script:PathWasExplicit = $PSBoundParameters.ContainsKey("Path") -and -not [string]::IsNullOrWhiteSpace($Path)
$script:ProgressIds = @{
    Hidden = 10
    Mods = 11
    Runtime = 12
    MemoryTargets = 13
    MemoryBytes = 14
}

function Disable-XmaConsoleQuickEdit {
    # Prevent console freeze when the user clicks/selects text in the window.
    try {
        if (-not ("XmaConsoleNative" -as [type])) {
            Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class XmaConsoleNative {
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out int lpMode);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool SetConsoleMode(IntPtr hConsoleHandle, int dwMode);
}
"@ -ErrorAction Stop
        }

        $stdInputHandle = [XmaConsoleNative]::GetStdHandle(-10)
        $invalidHandle = [IntPtr]::new(-1)
        if ($stdInputHandle -eq [IntPtr]::Zero -or $stdInputHandle -eq $invalidHandle) {
            return
        }

        $mode = 0
        if (-not [XmaConsoleNative]::GetConsoleMode($stdInputHandle, [ref]$mode)) {
            return
        }

        $enableExtendedFlags = 0x0080
        $enableQuickEditMode = 0x0040
        $newMode = $mode -bor $enableExtendedFlags
        $newMode = $newMode -band (-bnot $enableQuickEditMode)
        if ($newMode -ne $mode) {
            [void][XmaConsoleNative]::SetConsoleMode($stdInputHandle, $newMode)
        }
    } catch {
    }
}

function Write-XmaProgress {
    param(
        [Parameter(Mandatory)]
        [int]$Id,
        [Parameter(Mandatory)]
        [string]$Activity,
        [Parameter(Mandatory)]
        [string]$Status,
        [double]$Current = 0,
        [double]$Total = 100
    )

    if ($Quiet) { return }
    $safeTotal = if ($Total -le 0) { 1 } else { $Total }
    $safeCurrent = [Math]::Max(0, [Math]::Min($Current, $safeTotal))
    $percent = [int][Math]::Floor(($safeCurrent / [double]$safeTotal) * 100)
    Write-Progress -Id $Id -Activity $Activity -Status $Status -PercentComplete $percent
}

function Complete-XmaProgress {
    param(
        [Parameter(Mandatory)]
        [int]$Id,
        [Parameter(Mandatory)]
        [string]$Activity
    )

    if ($Quiet) { return }
    Write-Progress -Id $Id -Activity $Activity -Completed
}

function Write-XmaRule {
    param([string]$Color = "DarkGray")
    if ($Quiet) { return }
    Write-Host ("=" * 70) -ForegroundColor $Color
}

function Write-XmaSection {
    param(
        [Parameter(Mandatory)]
        [string]$Title,
        [string]$Color = "Cyan"
    )

    if ($Quiet) { return }
    Write-Host ""
    Write-Host ("[ " + $Title + " ]") -ForegroundColor $Color
}

function Write-XmaSummaryLine {
    param(
        [Parameter(Mandatory)]
        [string]$Label,
        [Parameter(Mandatory)]
        [int]$Count,
        [Parameter(Mandatory)]
        [int]$Total,
        [Parameter(Mandatory)]
        [string]$Color
    )

    $safeTotal = if ($Total -le 0) { 1 } else { $Total }
    $pct = [math]::Round(($Count / [double]$safeTotal) * 100, 1)
    $line = "{0,-18} {1,4}/{2,-4} ({3,5}%)" -f ($Label + ":"), $Count, $Total, $pct
    Write-Host $line -ForegroundColor $Color
}

function Format-XmaDuration {
    param([timespan]$Span)

    if ($Span.TotalSeconds -lt 0) {
        $Span = [timespan]::Zero
    }

    $hours = [int][math]::Floor($Span.TotalHours)
    return "{0:00}:{1:00}:{2:00}" -f $hours, $Span.Minutes, $Span.Seconds
}

function Test-XmaLikelyLauncherModsPath {
    param([string]$Path)

   