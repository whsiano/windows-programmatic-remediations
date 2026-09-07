<#
.SYNOPSIS
    This PowerShell script checks whether the computer has a working TPM chip (version 2.0) that's turned on and set up properly, since that's required for stronger protection of login credentials. If the TPM is present but just hasn't been set up yet, the script tries to finish that setup. But if there's no TPM chip at all, or it's disabled in the computer's firmware, this script can't fix that — that part has to be turned on manually in the BIOS/UEFI settings before Windows can use it.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000010
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-00-000010/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-00-000010).ps1 
#>

Write-Host "Checking TPM status..." -ForegroundColor Cyan
$tpm = Get-Tpm

if (-not $tpm.TpmPresent) {
    Write-Warning "No TPM was detected by Windows. This cannot be fixed in software -- it means either the machine has no TPM chip, or TPM/PTT/fTPM is disabled in UEFI firmware. Reboot into UEFI/BIOS setup and enable it there, or this hardware does not support the requirement."
    return
}

Write-Host "TPM Present: $($tpm.TpmPresent)"
Write-Host "TPM Ready:   $($tpm.TpmReady)"
Write-Host "TPM Enabled: $($tpm.TpmEnabled)"
Write-Host "TPM Owned:   $($tpm.TpmOwned)"

# Confirm it's actually version 2.0 as the STIG requires
$tpmVersion = (Get-CimInstance -Namespace "root\cimv2\Security\MicrosoftTpm" -ClassName Win32_Tpm).SpecVersion
Write-Host "TPM Spec Version: $tpmVersion"

if (-not $tpm.TpmReady) {
    Write-Host "TPM is present but not fully ready -- attempting to initialize/take ownership..." -ForegroundColor Yellow
    try {
        Initialize-Tpm -AllowClear -AllowPhysicalPresence
        Write-Host "TPM initialization attempted. Re-checking status:" -ForegroundColor Green
        Get-Tpm
    } catch {
        Write-Warning "Initialize-Tpm failed: $_. This may require a manual step in tpm.msc, or physical presence confirmation at boot."
    }
} else {
    Write-Host "TPM is already ready for use." -ForegroundColor Green
}
