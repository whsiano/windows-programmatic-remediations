<#
.SYNOPSIS
    This PowerShell script makes sure only Administrator accounts are allowed to restore backed-up files on this computer — removing that ability from any other account or group (like Backup Operators) that had it by default. This matters because restoring files lets someone bypass normal file permissions entirely, so it's a powerful ability that shouldn't be handed out beyond admins.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-07
    Last Modified   : 2026-09-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-UR-000160
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-UR-000160/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-UR-000160).ps1 
#>

$workDir = Join-Path $env:TEMP "STIG_WN11-UR-000160"
New-Item -ItemType Directory -Path $workDir -Force | Out-Null
$cfgPath = Join-Path $workDir "secpol.cfg"
$dbPath  = Join-Path $workDir "secedit.sdb"

# --- Export current local security policy ---
secedit /export /cfg $cfgPath /areas USER_RIGHTS /quiet

$content = Get-Content $cfgPath

# --- Force SeRestorePrivilege to contain ONLY Administrators (BUILTIN\Administrators = S-1-5-32-544) ---
# Unlike a "Deny" right, this right must NOT be merged with existing entries --
# anything other than Administrators (e.g. the default Backup Operators) is itself the finding.
$newLine = "SeRestorePrivilege = *S-1-5-32-544"

$lineIndex = -1
for ($i = 0; $i -lt $content.Count; $i++) {
    if ($content[$i] -match '^SeRestorePrivilege\s*=') {
        $lineIndex = $i
    }
}

if ($lineIndex -ge 0) {
    $content[$lineIndex] = $newLine
} else {
    $sectionLine = ($content | Select-String -Pattern '^\[Privilege Rights\]$').LineNumber
    if ($sectionLine) {
        $content = $content[0..($sectionLine - 1)] + $newLine + $content[$sectionLine..($content.Count - 1)]
    } else {
        $content += @("[Privilege Rights]", $newLine)
    }
}

$content | Set-Content -Path $cfgPath -Encoding Unicode

# --- Apply it ---
secedit /configure /db $dbPath /cfg $cfgPath /areas USER_RIGHTS /quiet
gpupdate /target:computer /force | Out-Null

Write-Host "Done. Verifying..." -ForegroundColor Green
secedit /export /cfg (Join-Path $workDir "verify.cfg") /areas USER_RIGHTS /quiet
Select-String -Path (Join-Path $workDir "verify.cfg") -Pattern "SeRestorePrivilege"

Remove-Item $workDir -Recurse -Force
