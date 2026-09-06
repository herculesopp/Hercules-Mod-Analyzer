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
        "autoclicker",
        "aimassist",
        "aim assist",
        "autocrystal",
        "auto crystal",
        "autohitcrystal",
        "autoanchor",
        "anchor macro",
        "anchortweaks",
        "doubleanchor",
        "safeanchor",
        "airanchor",
        "autototem",
        "auto totem",
        "inventorytotem",
        "hovertotem",
        "legittotem",
        "autopot",
        "autoarmor",
        "autoeat",
        "automine",
        "automace",
        "maceswap",
        "spearswap",
        "autodoublehand",
        "shielddisabler",
        "shieldbreaker",
        "triggerbot",
        "silentaim",
        "silent rotations",
        "fakelag",
        "pingspoof",
        "fakeinv",
        "webmacro",
        "authbypass",
        "obfuscatedauth",
        "licensecheckmixin",
        "clientplayerinteractionmanageraccessor",
        "clientplayerentitymixim",
        "itemexploit",
        "invsee",
        "basefinder",
        "packspoof",
        "antiknockback",
        "lagreach",
        "jumpreset",
        "axespam",
        "autofirework",
        "elytraswap",
        "fastxp",
        "fastexp",
        "nojumpdelay",
        "noclip",
        "freecam",
        "freezeplayer",
        "autobreach",
        "keypearl",
        "lootyeeter",
        "walksyoptimizer",
        "walskyoptimizer",
        "walksycrystaloptimizermod",
        "dqrkis",
        "argon",
        "xenon",
        "catlean",
        "gypsy",
        "hellion",
        "dev.krypton",
        "dev.gambleclient",
        "org.chainlibs.module.impl.modules.crystal",
        "org.chainlibs.module.impl.modules.blatant",
        "jnativehook",
        "phantom-refmap",
        "ghost client",
        "cracked client",
        "cracked",
        "reach",
        "velocity",
        "killaura",
        "scaffold",
        "fly",
        "speed",
        "esp",
        "xray",
        "selfdestruct",
        "self destruct",
        "bypass",
        "exploit"
    )
    TokenWeights = @{
        autoclicker = 3
        aimassist = 3
        "aim assist" = 3
        autocrystal = 3
        "auto crystal" = 2
        autohitcrystal = 3
        autoanchor = 3
        "anchor macro" = 2
        doubleanchor = 2
        safeanchor = 2
        autototem = 3
        "auto totem" = 3
        inventorytotem = 3
        hovertotem = 3
        legittotem = 2
        autopot = 2
        autoarmor = 2
        automace = 2
        maceswap = 2
        spearswap = 2
        shielddisabler = 3
        shieldbreaker = 3
        triggerbot = 3
        silentaim = 3
        pingspoof = 2
        fakeinv = 2
        fakelag = 2
        webmacro = 2
        authbypass = 4
        obfuscatedauth = 4
        licensecheckmixin = 4
        itemexploit = 3
        basefinder = 2
        packspoof = 2
        antiknockback = 2
        lagreach = 2
        jumpreset = 2
        axespam = 2
        autofirework = 2
        elytraswap = 2
        fastxp = 2
        fastexp = 2
        nojumpdelay = 2
        noclip = 2
        freecam = 2
        freezeplayer = 2
        autobreach = 2
        lootyeeter = 2
        walksyoptimizer = 4
        walskyoptimizer = 4
        walksycrystaloptimizermod = 4
        dqrkis = 4
        argon = 3
        xenon = 3
        catlean = 3
        gypsy = 3
        hellion = 3
        "dev.krypton" = 4
        "dev.gambleclient" = 4
        "org.chainlibs.module.impl.modules.crystal" = 4
        "org.chainlibs.module.impl.modules.blatant" = 4
        jnativehook = 3
        "phantom-refmap" = 3
        "ghost client" = 4
        "cracked client" = 4
        cracked = 2
        killaura = 3
        xray = 3
        selfdestruct = 3
        "self destruct" = 3
        bypass = 3
        exploit = 3
        scaffold = 2
        fly = 2
        reach = 2
        esp = 2
        velocity = 1
        speed = 1
    }
    CriticalCheatTokens = @(
        "dqrkis",
        "walksyoptimizer",
        "walskyoptimizer",
        "walksycrystaloptimizermod",
        "authbypass",
        "obfuscatedauth",
        "licensecheckmixin",
        "dev.krypton",
        "dev.gambleclient",
        "org.chainlibs.module.impl.modules.crystal",
        "org.chainlibs.module.impl.modules.blatant",
        "ghost client",
        "cracked client",
        "catlean",
        "xenon",
        "gypsy",
        "hellion"
    )
    CheatSignatureStrings = @(
        "Dqrkis Client (Cracked)",
        "A.utomatically hit-crystals for you",
        "Automatically attacks while falling with mace.",
        "MemoryModuleHelper",
        "renderModuleList",
        "moduleToggleAnim",
        "VIEW_LABEL_MODULES",
        "VIEW_ICON_MODULES",
        "modulePreview",
        "modulesButton",
        "selectedModule",
        "ModuleRegistry",
        "ModModule",
        "AutoCrystal",
        "AutoAnchor",
        "Anchor Macro",
        "InventoryTotem",
        "HoverTotem",
        "ShieldDisabler",
        "TriggerBot",
        "FakeInv",
        "PingSpoof"
    )
    HighConfidenceSignatureStrings = @(
        "Dqrkis Client (Cracked)",
        "A.utomatically hit-crystals for you",
        "Automatically attacks while falling with mace.",
        "MemoryModuleHelper",
        "moduleToggleAnim",
        "VIEW_LABEL_MODULES",
        "VIEW_ICON_MODULES",
        "ModuleRegistry",
        "ModModule"
    )
    MemoryFilterStrings = @(
        "Doomsday",
        "DoomsdayClient",
        "DoomsdayClient:::bot),%.R",
        "DoomsdayClient:::u;<r,7NVce;Ga25",
        "DoomsdayClient:::eObOiPdFJR 2",
        "DoomsdayClient:::Wu&XNC]30?3=7",
        "prestige",
        "*.prestigeclient.vip0",
        "prestigeclient.vip",
        "prestigeclient.vip0Y0",
        "prestige_4.properties",
        ".prestigeclient.vip0",
        "assets/minecraft/optifine/cit/profile/prestige/",
        ".psaclient",
        "198m",
        "Auto Crystal",
        "Anchor Macro",
        "fastplace",
        "autocrystal",
        "legit totem",
        "CrystalAura",
        "AnchorAura",
        "LegitRetotem",
        "Auto Dtap",
        "Auto Hit Crystal",
        "Self Destruct",
        "AutoInventoryTotem",
        "Auto Shield Disabler",
        "Auto Mace",
        "Aimbot"
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
        "jmxremote",
        "jacoco",
        "newrelic",
        "jrebel",
        "yjp",
        "theseus",
        "lombok",
        "byte-buddy",
        "idea_rt",
        "intellij",
        "jetbrains",
        "visualvm",
        "async-profiler",
        "hprof",
        "flightrecorder",
        "jfr"
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

   