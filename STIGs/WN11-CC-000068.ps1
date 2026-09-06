<#
.SYNOPSIS
    This PowerShell script turns on a Windows setting that protects your login credentials during Remote Desktop connections, so a remote machine only gets a locked-down, non-reusable version of your credentials instead of one that could be stolen and reused elsewhere.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-06
    Last Modified   : 2026-09-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000068
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000068/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-CC-000068).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "AllowProtectedCreds" -Value 1 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "AllowProtectedCreds").AllowProtectedCreds
Write-Host "AllowProtectedCreds is now set to $check" -ForegroundColor Green
