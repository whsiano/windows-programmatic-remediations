<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-05
    Last Modified   : 2026-09-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500
    Documentation   : https://stigaview.com/products/win11/v2r3/WN11-AU-000500/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

#Requires -RunAsAdministrator

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# MaxSize is in KB for this policy key. STIG requires 32768 KB (32 MB) or greater.
New-ItemProperty -Path $regPath -Name "MaxSize" -Value 32768 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "MaxSize").MaxSize
Write-Host "MaxSize is now $check KB" -ForegroundColor Green
