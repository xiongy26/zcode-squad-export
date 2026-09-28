$ErrorActionPreference = 'Stop'

# Install the squad configuration into the current user's .zcode directory.
$sourceRoot = $PSScriptRoot
$targetRoot = Join-Path $HOME '.zcode'
$targetAgents = Join-Path $targetRoot 'agents'
$targetSquad = Join-Path $targetRoot 'squad'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Backup-FileIfPresent {
    param(
        [string]$Path,
        [string]$BackupPath
    )

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Copy-Item -LiteralPath $Path -Destination $BackupPath -Force
        Write-Host "Backed up $Path -> $BackupPath"
    }
}

function Backup-DirectoryIfPresent {
    param(
        [string]$Path,
        [string]$BackupPath
    )

    if (Test-Path -LiteralPath $Path -PathType Container) {
        New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
        Copy-Item -Path (Join-Path $Path '*') -Destination $BackupPath -Recurse -Force
        Write-Host "Backed up $Path -> $BackupPath"
    }
}

Backup-FileIfPresent (Join-Path $targetRoot 'AGENTS.md') (Join-Path $targetRoot "AGENTS.md.bak-$timestamp")
Backup-DirectoryIfPresent $targetAgents (Join-Path $targetRoot "agents.bak-$timestamp")
Backup-DirectoryIfPresent $targetSquad (Join-Path $targetRoot "squad.bak-$timestamp")

New-Item -ItemType Directory -Path $targetAgents, $targetSquad -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $sourceRoot 'AGENTS.md') -Destination (Join-Path $targetRoot 'AGENTS.md') -Force
Get-ChildItem -LiteralPath (Join-Path $sourceRoot 'agents') -Filter '*.md' -File | Copy-Item -Destination $targetAgents -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot '探索者小队协作政策.md') -Destination (Join-Path $targetRoot '探索者小队协作政策.md') -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot 'install.sh'), (Join-Path $sourceRoot 'install.ps1'), (Join-Path $sourceRoot 'pack.sh'), (Join-Path $sourceRoot 'pack.ps1'), (Join-Path $sourceRoot 'README.md') -Destination $targetSquad -Force

Write-Host ''
Write-Host 'Installation complete:'
Get-ChildItem -LiteralPath $targetAgents -Filter '*.md' | ForEach-Object { Write-Host $_.FullName }
Write-Host 'Open a new ZCode conversation for the configuration to take effect.'
Write-Host 'To repackage after editing ~/.zcode, run & $HOME\.zcode\squad\pack.ps1 [output-directory] in PowerShell.'
