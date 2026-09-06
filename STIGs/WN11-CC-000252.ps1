<#
.SYNOPSIS
    This PowerShell script turns off Windows Game Recording and Broadcasting (Game DVR/Xbox Game Bar recording) by setting a registry value, since that feature could accidentally capture screenshots or recordings of other applications and expose sensitive data.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-06
    Last Modified   : 2026-09-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000252
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000252/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-CC-000252).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "AllowGameDVR" -Value 0 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "AllowGameDVR").AllowGameDVR
Write-Host "AllowGameDVR is now set to $check" -ForegroundColor Green
