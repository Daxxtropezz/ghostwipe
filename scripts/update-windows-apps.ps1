#Requires -Version 5.1

<#
.SYNOPSIS
    Updates installed Windows applications using WinGet.

.DESCRIPTION
    Ghostwipe Windows application update helper.

    Administrator privileges are not required just to launch this script.
    Individual application installers may still request elevation through UAC.

.NOTES
    Keep this file inside the repository's scripts directory.
#>

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-GhostwipeInfo {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[Ghostwipe] $Message"
}

function Write-GhostwipeFailure {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[Ghostwipe] ERROR: $Message"
}

try {
    Write-GhostwipeInfo "Checking for WinGet..."

    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue

    if (-not $winget) {
        Write-GhostwipeFailure "WinGet is not installed or is not available in PATH."
        Write-GhostwipeInfo "Install or update App Installer from Microsoft, then run this script again."
        exit 1
    }

    Write-GhostwipeInfo "Checking for available application updates..."

    & $winget.Source upgrade `
        --all `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements `
        --include-unknown

    $wingetExitCode = $LASTEXITCODE

    if ($wingetExitCode -ne 0) {
        Write-GhostwipeFailure "WinGet exited with code $wingetExitCode."
        exit $wingetExitCode
    }

    Write-GhostwipeInfo "Application update process completed successfully."
}
catch {
    Write-GhostwipeFailure $_.Exception.Message
    exit 1
}
