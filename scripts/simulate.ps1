param([string]$Top = 'counter_tb', [string]$FileList = 'sim.f')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$compiler = 'D:/iverilog/bin/iverilog.exe'
$runtime = 'D:/iverilog/bin/vvp.exe'
Push-Location $projectRoot
try {
    if (!(Test-Path $compiler) -or !(Test-Path $runtime)) {
        throw 'Icarus not found in D:/iverilog/bin. Update scripts/simulate.ps1 and .vscode/settings.json.'
    }
    New-Item -ItemType Directory -Force -Path 'build' | Out-Null
    & $compiler -g2012 -Wall -s $Top -o 'build/simulation.vvp' -f $FileList
    if ($LASTEXITCODE -ne 0) { throw "Compilation failed (exit $LASTEXITCODE)." }
    & $runtime 'build/simulation.vvp'
    if ($LASTEXITCODE -ne 0) { throw "Simulation failed (exit $LASTEXITCODE)." }
} finally {
    Pop-Location
}
