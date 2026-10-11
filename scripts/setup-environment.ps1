param(
    [string]$IcarusBin,
    [switch]$InstallExtensions
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
if (!$IcarusBin) {
    $found = Get-Command iverilog.exe -ErrorAction SilentlyContinue
    if ($found) { $IcarusBin = Split-Path $found.Source -Parent }
    elseif (Test-Path 'D:/iverilog/bin/iverilog.exe') { $IcarusBin = 'D:/iverilog/bin' }
    else { throw 'Install Icarus first, then pass -IcarusBin <installation/bin>.' }
}
$IcarusBin = (Resolve-Path -LiteralPath $IcarusBin).Path
foreach ($exe in @('iverilog.exe', 'vvp.exe')) {
    if (!(Test-Path -LiteralPath (Join-Path $IcarusBin $exe))) { throw "Missing $exe in $IcarusBin" }
}
$settingsPath = Join-Path $projectRoot '.vscode/settings.json'
$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
$settings.'verilog.linting.path' = $IcarusBin.Replace('\', '/')
$terminalPath = $IcarusBin + ';${env:PATH}'
$git = Get-Command git.exe -ErrorAction SilentlyContinue
if ($git) {
    $settings | Add-Member -NotePropertyName 'git.path' -NotePropertyValue $git.Source -Force
    $terminalPath = (Split-Path $git.Source -Parent) + ';' + $terminalPath
} else {
    $settings.PSObject.Properties.Remove('git.path')
    Write-Warning 'Git is not on PATH. Install Git and restart VS Code for repository sync.'
}
$settings.'terminal.integrated.env.windows'.PATH = $terminalPath
$utf8 = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText($settingsPath, ($settings | ConvertTo-Json -Depth 10) + [Environment]::NewLine, $utf8)
if ($InstallExtensions) {
    $code = Get-Command code.cmd -ErrorAction Stop
    $extensions = Get-Content (Join-Path $projectRoot '.vscode/extensions.json') -Raw | ConvertFrom-Json
    foreach ($id in $extensions.recommendations) {
        & $code.Source --install-extension $id
        if ($LASTEXITCODE -ne 0) { throw "Extension installation failed: $id" }
    }
}
& (Join-Path $PSScriptRoot 'simulate.ps1')
Write-Host 'Setup verified. Reload VS Code and open a new terminal.'
