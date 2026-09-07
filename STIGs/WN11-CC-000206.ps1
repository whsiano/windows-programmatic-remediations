<#
.SYNOPSIS
    This PowerShell script controls how Windows downloads updates — it makes sure the computer isn't sharing or receiving Windows Update files with random devices out on the open internet ("Internet" peer-to-peer mode). Instead, it restricts that update-sharing to only devices on the same local network, which keeps update traffic from leaking outside the organization's own network.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000206 
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000206/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-CC-000206).ps1 
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name "DODownloadMode" -Value 1 -PropertyType DWord -Force | Out-Null

$check = (Get-ItemProperty -Path $regPath -Name "DODownloadMode").DODownloadMode
Write-Host "DODownloadMode is now set to $check (LAN peering)" -ForegroundColor Green
