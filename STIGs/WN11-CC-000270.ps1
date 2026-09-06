<#
.SYNOPSIS
    This PowerShell script stops Windows from letting Remote Desktop Connection save your password for future logins, so you have to type it in every time you connect — which prevents someone else from just clicking "connect" and getting in using a saved password.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-06
    Last Modified   : 2026-09-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000270
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000270/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STID-ID-WN11-CC-000270).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "DisablePasswordSaving" -Value 1 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "DisablePasswordSaving").DisablePasswordSaving
Write-Host "DisablePasswordSaving is now set to $check" -ForegroundColor Green
