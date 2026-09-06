# HerculesModAnalyzer.ps1
# Customized branding of Xkzuto's Mod Analyzer.
# Original project:
# https://raw.githubusercontent.com/xkzuto96/xkzutos-mod-analyzer/main/XkzutosModAnalyzer.ps1

[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [object[]]$Arguments
)

$ErrorActionPreference = "Stop"

$SourceUrl = "https://raw.githubusercontent.com/xkzuto96/xkzutos-mod-analyzer/main/XkzutosModAnalyzer.ps1"
$CachePath = Join-Path $env:TEMP "HerculesModAnalyzer-Upstream.ps1"
$BrandedPath = Join-Path $env:TEMP "HerculesModAnalyzer-Branded.ps1"

try {
    # Download the original analyzer.
    Invoke-WebRequest -Uri $SourceUrl -OutFile $CachePath -UseBasicParsing

    # Replace the analyzer's owner/creator branding with Hercules.
    $ScriptText = Get-Content -LiteralPath $CachePath -Raw -Encoding UTF8
    $ScriptText = $ScriptText.Replace('Creator = "xKzuto"', 'Creator = "Hercules"')
    $ScriptText = $ScriptText.Replace('Name = "xkzuto''s mod analyzer"', 'Name = "Hercules Mod Analyzer"')

    # Also update the standard header/comment branding if present.
    $ScriptText = $ScriptText.Replace("xKzuto's Mod Analyzer", "Hercules Mod Analyzer")
    $ScriptText = $ScriptText.Replace("xKzuto's mod analyzer", "Hercules Mod Analyzer")

    $ProgressPatch = @'
    if ($Quiet) { return }

    # Use purple for Java/JVM PID progress scans instead of the default blue.
    try {
        if ($Activity -match '(?i)JVM|PID|Memory target|Memory strings') {
            $Host.PrivateData.ProgressBackgroundColor = "DarkMagenta"
            $Host.PrivateData.ProgressForegroundColor = "White"
        }
    } catch {
    }

    $safeTotal = if ($Total -le 0) { 1 } else { $Total }
'@
    $ScriptText = $ScriptText.Replace(
        @'
    if ($Quiet) { return }
    $safeTotal = if ($Total -le 0) { 1 } else { $Total }
'@,
        $ProgressPatch
    )

    Set-Content -LiteralPath $BrandedPath -Value $ScriptText -Encoding UTF8

    # Run the branded version with all arguments passed to this script.
    & $BrandedPath @Arguments
    exit $LASTEXITCODE
}
catch {
    Write-Error "Failed to download, brand, or run Hercules Mod Analyzer: $($_.Exception.Message)"
    exit 1
}
