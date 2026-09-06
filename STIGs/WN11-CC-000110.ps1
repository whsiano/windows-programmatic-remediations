<#
.SYNOPSIS
    This PowerShell script turns off Windows' ability to print over HTTP (i.e., to internet/web-based printers) by setting a registry value that disables that feature.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-06
    Last Modified   : 2026-09-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000110
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000110/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-CC-000110).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "DisableHTTPPrinting" -Value 1 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "DisableHTTPPrinting").DisableHTTPPrinting
Write-Host "DisableHTTPPrinting is now set to $check" -ForegroundColor Green
