param([string]$Top = 'counter_tb', [string]$FileList = 'sim.f')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$compiler = 'D:/iverilog/bin/iverilog.exe'
$runtime = 'D:/iverilog/bin/vvp.exe'
$settingsPath = Join-Path $projectRoot '.vscode/settings.json'
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
    $bin = $settings.'verilog.linting.path'
    if ($bin) {
        $compiler = Join-Path $bin 'iverilog.exe'
        $runtime = Join-Path $bin 'vvp.exe'
    }
}
Push-Location $projectRoot
try {
    if (!(Test-Path $compiler) -or !(Test-Path $runtime)) {
        throw 'Icarus not found. Run scripts/setup-environment.ps1 -IcarusBin <installation/bin>.'
    }
    New-Item -ItemType Directory -Force -Path 'build' | Out-Null
    & $compiler -g2012 -Wall -s $Top -o 'build/simulation.vvp' -f $FileList
    if ($LASTEXITCODE -ne 0) { throw "Compilation failed (exit $LASTEXITCODE)." }
    & $runtime 'build/simulation.vvp'
    if ($LASTEXITCODE -ne 0) { throw "Simulation failed (exit $LASTEXITCODE)." }
} finally {
    Pop-Location
}
