param(
    [ValidateSet('counter', 'full-adder', 'mux4to1', 'pad', 'process-loop', 'endian-reverse')]
    [string]$Example = 'counter',
    [string]$Top,
    [string]$FileList
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$cases = @{
    'counter' = @{ Folder = '01-counter'; Top = 'counter_tb'; Sources = @('counter.sv', 'counter_tb.sv') }
    'full-adder' = @{ Folder = '02-full-adder'; Top = 'tb_full_adder4'; Sources = @('full_adder4.v', 'tb_full_adder4.v') }
    'mux4to1' = @{ Folder = '03-mux4to1'; Top = 'tb_mux4to1'; Sources = @('mux4to1.v', 'tb_mux4to1.v') }
    'pad' = @{ Folder = '04-pad'; Top = 'tb_pad'; Sources = @('pad.v', 'tb_pad.v') }
    'process-loop' = @{ Folder = '05-process-loop'; Top = 'runoob'; Sources = @('runoob.v') }
    'endian-reverse' = @{ Folder = '06-endian-reverse'; Top = 'endian_rvs'; Sources = @('endian_rvs.v') }
}
$case = $cases[$Example]
if (!$Top) { $Top = $case.Top }
$sourceDir = Join-Path $projectRoot ('examples/' + $case.Folder)
$outputDir = Join-Path $projectRoot ('build/examples/' + $case.Folder)
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
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    $outputFile = Join-Path $outputDir 'simulation.vvp'
    $compileArgs = @('-g2012', '-Wall', '-s', $Top, '-o', $outputFile)
    if ($FileList) {
        $compileArgs += @('-f', $FileList)
    } else {
        foreach ($source in $case.Sources) { $compileArgs += (Join-Path $sourceDir $source) }
    }
    & $compiler @compileArgs
    if ($LASTEXITCODE -ne 0) { throw "Compilation failed (exit $LASTEXITCODE)." }
    Set-Location -LiteralPath $outputDir
    & $runtime $outputFile
    if ($LASTEXITCODE -ne 0) { throw "Simulation failed (exit $LASTEXITCODE)." }
    Write-Host "Output: $outputDir"
} finally {
    Pop-Location
}
