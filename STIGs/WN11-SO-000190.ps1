<#
.SYNOPSIS
    This PowerShell script tells Windows to stop using old, weak types of encryption (DES and RC4) when handling Kerberos logins — the system that verifies who you are on a network — and only allow newer, stronger encryption (AES) instead. This makes it much harder for an attacker to crack or forge login credentials on the network.
.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000190
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-SO-000190/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-SO-000190).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "SupportedEncryptionTypes" -Value 0x7ffffff8 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "SupportedEncryptionTypes").SupportedEncryptionTypes
Write-Host "SupportedEncryptionTypes is now set to $check ($('0x{0:x}' -f $check))" -ForegroundColor Green
