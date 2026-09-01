#Requires -Version 5.1

<#
.SYNOPSIS
    Interactive Windows maintenance helper for Ghostwipe.

.DESCRIPTION
    Menu-driven Windows maintenance actions:

      1. Update installed applications with WinGet
      2. Clear %TEMP%, C:\Windows\Temp, and C:\Windows\Prefetch
      3. Empty the Recycle Bin
      4. Run SFC /scannow, DISM /RestoreHealth, then SFC /scannow again
      5. Run all maintenance actions

    Administrator privileges are requested only when the selected action
    requires them. Administrator-only actions are relaunched through UAC
    instead of terminating with a PowerShell Write-Error stack trace.

.NOTES
    Keep this file inside the repository's scripts directory beside:
      update-windows-apps.ps1
#>

[CmdletBinding()]
param(
    [ValidateSet("Menu", "UpdateApps", "CleanupTemp", "RecycleBin", "RepairWindows", "All")]
    [string]$Action = "Menu"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDirectory = Split-Path -Parent $ScriptPath
$UpdateAppsScript = Join-Path $ScriptDirectory "update-windows-apps.ps1"

function Write-GhostwipeInfo {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[Ghostwipe] $Message"
}

function Write-GhostwipeWarning {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[Ghostwipe] WARNING: $Message"
}

function Write-GhostwipeFailure {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "[Ghostwipe] ERROR: $Message"
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Test-ActionRequiresAdministrator {
    param([Parameter(Mandatory)][string]$SelectedAction)

    return $SelectedAction -in @("CleanupTemp", "RepairWindows", "All")
}

function Invoke-ElevatedAction {
    param([Parameter(Mandatory)][string]$SelectedAction)

    Write-GhostwipeInfo "Administrator privileges are required for this selection."
    Write-GhostwipeInfo "Requesting permission through Windows UAC..."

    $arguments = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", "`"$ScriptPath`"",
        "-Action", $SelectedAction
    )

    try {
        $process = Start-Process `
            -FilePath "powershell.exe" `
            -Verb RunAs `
            -ArgumentList $arguments `
            -Wait `
            -PassThru

        if ($process.ExitCode -ne 0) {
            Write-GhostwipeWarning "The elevated task ended with exit code $($process.ExitCode)."
        }

        return
    }
    catch {
        Write-GhostwipeWarning "Administrator permission was not granted. No administrator-only changes were made."
        return
    }
}

function Remove-DirectoryContents {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$DisplayName
    )

    Write-GhostwipeInfo "Clearing $DisplayName..."

    if (-not (Test-Path -LiteralPath $Path)) {
        Write-GhostwipeWarning "$DisplayName was not found: $Path"
        return
    }

    $removed = 0
    $skipped = 0
    $items = @(Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue)

    foreach ($item in $items) {
        try {
            Remove-Item -LiteralPath $item.FullName -Recurse -Force -ErrorAction Stop
            $removed++
        }
        catch {
            $skipped++
        }
    }

    if ($skipped -gt 0) {
        Write-GhostwipeInfo "$DisplayName cleanup completed. Removed: $removed | Skipped/in use: $skipped"
    }
    else {
        Write-GhostwipeInfo "$DisplayName cleanup completed. Removed: $removed"
    }
}

function Invoke-ApplicationUpdates {
    Write-Host ""

    if (-not (Test-Path -LiteralPath $UpdateAppsScript)) {
        Write-GhostwipeFailure "update-windows-apps.ps1 was not found beside this script."
        Write-GhostwipeInfo "Keep both PowerShell files inside the repository's scripts directory."
        return
    }

    Write-GhostwipeInfo "Starting application update helper..."

    & powershell.exe `
        -NoProfile `
        -ExecutionPolicy Bypass `
        -File $UpdateAppsScript

    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0) {
        Write-GhostwipeWarning "Application updates ended with exit code $exitCode."
    }
}

function Invoke-TempCleanup {
    Write-Host ""
    Write-GhostwipeInfo "Starting temporary-file cleanup..."

    Remove-DirectoryContents `
        -Path $env:TEMP `
        -DisplayName "%TEMP%"

    Remove-DirectoryContents `
        -Path (Join-Path $env:SystemRoot "Temp") `
        -DisplayName "Windows Temp"

    Remove-DirectoryContents `
        -Path (Join-Path $env:SystemRoot "Prefetch") `
        -DisplayName "Windows Prefetch"

    Write-GhostwipeInfo "Temporary-file cleanup completed."
}

function Invoke-RecycleBinCleanup {
    Write-Host ""
    Write-GhostwipeInfo "Emptying Recycle Bin..."

    try {
        Clear-RecycleBin -Force -ErrorAction Stop
        Write-GhostwipeInfo "Recycle Bin emptied successfully."
    }
    catch {
        $message = $_.Exception.Message

        if ($message -match "cannot find|does not exist|empty") {
            Write-GhostwipeInfo "Recycle Bin is already empty."
        }
        else {
            Write-GhostwipeWarning "Recycle Bin could not be fully cleared: $message"
        }
    }
}

function Invoke-NativeRepairCommand {
    param(
        [Parameter(Mandatory)][string]$Description,
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string[]]$Arguments
    )

    Write-Host ""
    Write-GhostwipeInfo $Description

    & $FilePath @Arguments
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Write-GhostwipeInfo "Completed successfully."
    }
    else {
        Write-GhostwipeWarning "Command finished with exit code $exitCode."
    }
}

function Invoke-WindowsRepair {
    Write-Host ""
    Write-GhostwipeInfo "Starting Windows system repair sequence."

    Write-GhostwipeInfo "Step 1 of 3: SFC /scannow"
    Invoke-NativeRepairCommand `
        -Description "Running System File Checker..." `
        -FilePath "sfc.exe" `
        -Arguments @("/scannow")

    Write-GhostwipeInfo "Step 2 of 3: DISM /Online /Cleanup-Image /RestoreHealth"
    Invoke-NativeRepairCommand `
        -Description "Repairing the Windows component store with DISM..." `
        -FilePath "dism.exe" `
        -Arguments @("/Online", "/Cleanup-Image", "/RestoreHealth")

    Write-GhostwipeInfo "Step 3 of 3: SFC /scannow"
    Invoke-NativeRepairCommand `
        -Description "Running System File Checker again after DISM..." `
        -FilePath "sfc.exe" `
        -Arguments @("/scannow")

    Write-Host ""
    Write-GhostwipeInfo "Windows system repair sequence completed."
}

function Invoke-SelectedAction {
    param([Parameter(Mandatory)][string]$SelectedAction)

    if ((Test-ActionRequiresAdministrator -SelectedAction $SelectedAction) -and
        -not (Test-IsAdministrator)) {

        Invoke-ElevatedAction -SelectedAction $SelectedAction
        return
    }

    switch ($SelectedAction) {
        "UpdateApps" {
            Invoke-ApplicationUpdates
        }

        "CleanupTemp" {
            Invoke-TempCleanup
        }

        "RecycleBin" {
            Invoke-RecycleBinCleanup
        }

        "RepairWindows" {
            Invoke-WindowsRepair
        }

        "All" {
            Invoke-ApplicationUpdates
            Invoke-TempCleanup
            Invoke-RecycleBinCleanup
            Invoke-WindowsRepair

            Write-Host ""
            Write-GhostwipeInfo "All Windows maintenance tasks are complete."
        }
    }
}

function Show-GhostwipeMenu {
    while ($true) {
        Clear-Host

        Write-Host "=============================================="
        Write-Host "       Ghostwipe Windows Maintenance"
        Write-Host "=============================================="
        Write-Host ""
        Write-Host "  [1] Update installed applications"
        Write-Host "  [2] Clear TEMP, Windows Temp, and Prefetch"
        Write-Host "  [3] Empty Recycle Bin"
        Write-Host "  [4] Repair Windows (SFC -> DISM -> SFC)"
        Write-Host "  [5] Run all maintenance"
        Write-Host "  [0] Exit"
        Write-Host ""

        $selection = Read-Host "Select an option"

        switch ($selection) {
            "1" { Invoke-SelectedAction -SelectedAction "UpdateApps" }
            "2" { Invoke-SelectedAction -SelectedAction "CleanupTemp" }
            "3" { Invoke-SelectedAction -SelectedAction "RecycleBin" }
            "4" { Invoke-SelectedAction -SelectedAction "RepairWindows" }
            "5" { Invoke-SelectedAction -SelectedAction "All" }

            "0" {
                Write-Host ""
                Write-GhostwipeInfo "Exiting Windows maintenance."
                return
            }

            default {
                Write-Host ""
                Write-GhostwipeWarning "Invalid selection. Choose 0 through 5."
            }
        }

        Write-Host ""
        [void](Read-Host "Press Enter to return to the menu")
    }
}

try {
    if ($Action -eq "Menu") {
        Show-GhostwipeMenu
    }
    else {
        Invoke-SelectedAction -SelectedAction $Action
    }
}
catch {
    Write-Host ""
    Write-GhostwipeFailure $_.Exception.Message
    exit 1
}
