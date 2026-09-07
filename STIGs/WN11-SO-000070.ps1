<#
.SYNOPSIS
    This PowerShell script makes the computer automatically lock itself after 15 minutes of no activity (no mouse or keyboard use), so if someone walks away from their desk, the screen locks on its own instead of staying open and unprotected.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000070 
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-SO-000070/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-SO-000070 ).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "InactivityTimeoutSecs" -Value 900 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "InactivityTimeoutSecs").InactivityTimeoutSecs
Write-Host "InactivityTimeoutSecs is now set to $check seconds" -ForegroundColor Green
