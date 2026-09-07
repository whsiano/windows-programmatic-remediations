<#
.SYNOPSIS
    This PowerShell script turns off "Basic" authentication for Windows Remote Management (WinRM), so remote admin connections to this computer can't use a weak, easily-intercepted way of sending passwords — they're forced to use a more secure authentication method instead.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000345
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000345/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-CC-000345).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "AllowBasic" -Value 0 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "AllowBasic").AllowBasic
Write-Host "AllowBasic is now set to $check" -ForegroundColor Green
