<#
.SYNOPSIS
    This PowerShell script blocks Windows from connecting to shared folders that don't require a login (unsecured "guest" access), which protects against attackers intercepting or tampering with data on unauthenticated network shares.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000040
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000040/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-CC-000040).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "AllowInsecureGuestAuth" -Value 0 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "AllowInsecureGuestAuth").AllowInsecureGuestAuth
Write-Host "AllowInsecureGuestAuth is now set to $check" -ForegroundColor Green
