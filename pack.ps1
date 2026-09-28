param(
    [string]$OutputDirectory = '.'
)

$ErrorActionPreference = 'Stop'

# Package the installed squad configuration into zcode-squad.tar.gz.
$targetRoot = Join-Path $HOME '.zcode'
$squadDirectory = Join-Path $targetRoot 'squad'
$agentsDirectory = Join-Path $targetRoot 'agents'
$requiredFiles = @(
    (Join-Path $targetRoot 'AGENTS.md'),
    (Join-Path $targetRoot '探索者小队协作政策.md'),
    (Join-Path $squadDirectory 'install.sh'),
    (Join-Path $squadDirectory 'install.ps1'),
    (Join-Path $squadDirectory 'pack.sh'),
    (Join-Path $squadDirectory 'pack.ps1'),
    (Join-Path $squadDirectory 'README.md')
)

foreach ($requiredFile in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $requiredFile -PathType Leaf)) {
        throw "Missing $requiredFile. Run install.ps1 first."
    }
}

if (-not (Test-Path -LiteralPath $agentsDirectory -PathType Container)) {
    throw "Missing $agentsDirectory. Run install.ps1 first."
}

$agentFiles = @(Get-ChildItem -LiteralPath $agentsDirectory -Filter '*.md' -File)
if ($agentFiles.Count -eq 0) {
    throw "No agent definitions found in $agentsDirectory."
}

if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}
$outputPath = (Resolve-Path -LiteralPath $OutputDirectory).Path
$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("zcode-squad-" + [guid]::NewGuid().ToString('N'))
$exportRoot = Join-Path $stageRoot 'zcode-squad-export'
$archivePath = Join-Path $outputPath 'zcode-squad.tar.gz'

try {
    New-Item -ItemType Directory -Path (Join-Path $exportRoot 'agents') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $targetRoot 'AGENTS.md') -Destination $exportRoot -Force
    Copy-Item -LiteralPath (Join-Path $targetRoot '探索者小队协作政策.md') -Destination $exportRoot -Force
    Copy-Item -Path (Join-Path $agentsDirectory '*') -Destination (Join-Path $exportRoot 'agents') -Recurse -Force
    Copy-Item -LiteralPath (Join-Path $squadDirectory 'install.sh'), (Join-Path $squadDirectory 'install.ps1'), (Join-Path $squadDirectory 'pack.sh'), (Join-Path $squadDirectory 'pack.ps1'), (Join-Path $squadDirectory 'README.md') -Destination $exportRoot -Force

    if (Test-Path -LiteralPath $archivePath -PathType Leaf) {
        Remove-Item -LiteralPath $archivePath -Force
    }

    & tar.exe -czf $archivePath -C $stageRoot 'zcode-squad-export'
    if ($LASTEXITCODE -ne 0) {
        throw "tar.exe failed with exit code $LASTEXITCODE."
    }

    Write-Host "Created $archivePath (including $($agentFiles.Count) agent definitions)"
    Write-Host 'Distribute to another computer, extract the archive, then run .\install.ps1 in PowerShell.'
}
finally {
    if (Test-Path -LiteralPath $stageRoot) {
        Remove-Item -LiteralPath $stageRoot -Recurse -Force
    }
}
