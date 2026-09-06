<#
.SYNOPSIS
    This PowerShell script configures the "Deny access to this computer from the network" user right to block network logons from high-privilege domain accounts and local accounts on domain-joined systems, and from unauthenticated Guests access on all systems.

.NOTES
    Author          : Wilson Siano
    LinkedIn        : linkedin.com/in/whsianoo/
    GitHub          : github.com/whsiano
    Date Created    : 2026-09-06
    Last Modified   : 2026-09-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : N/A
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-UR-000070/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\(STIG-ID-WN11-UR-000070).ps1 
#>


# --- Safety check: this STIG targets Windows 11 workstations, not domain controllers ---
$productType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
if ($productType -eq 2) {
    Write-Error "This machine is a Domain Controller. Do NOT apply this workstation-scoped policy here — it would lock out domain admin network logons domain-wide. Aborting."
    return
}

$isDomainJoined = (Get-CimInstance -ClassName Win32_ComputerSystem).PartOfDomain

# --- Build the list of SIDs that must be present ---
$desiredSids = [System.Collections.Generic.List[string]]::new()

# All systems: Guests group (well-known local SID, same on every machine)
$desiredSids.Add("S-1-5-32-546")

if ($isDomainJoined) {
    # Local account (well-known special-principal SID)
    $desiredSids.Add("S-1-5-113")

    foreach ($groupName in @("Domain Admins", "Enterprise Admins")) {
        try {
            $sid = (New-Object System.Security.Principal.NTAccount($groupName)).
                   Translate([System.Security.Principal.SecurityIdentifier]).Value
            $desiredSids.Add($sid)
        } catch {
            Write-Warning "Could not resolve '$groupName' (may not exist/reachable from this machine — e.g. this may not be the forest root domain for Enterprise Admins): $_"
        }
    }
} else {
    Write-Host "Machine is not domain-joined — only the Guests group requirement applies." -ForegroundColor Yellow
}

# --- Export current local security policy ---
$workDir = Join-Path $env:TEMP "STIG_WN11-UR-000070"
New-Item -ItemType Directory -Path $workDir -Force | Out-Null
$cfgPath = Join-Path $workDir "secpol.cfg"
$dbPath  = Join-Path $workDir "secedit.sdb"

secedit /export /cfg $cfgPath /areas USER_RIGHTS /quiet

$content = Get-Content $cfgPath

# --- Find existing SeDenyNetworkLogonRight line and merge, rather than overwrite ---
$lineIndex = -1
$existingEntries = @()
for ($i = 0; $i -lt $content.Count; $i++) {
    if ($content[$i] -match '^SeDenyNetworkLogonRight\s*=\s*(.*)$') {
        $lineIndex = $i
        $existingEntries = $matches[1] -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
}

$allEntries = [System.Collections.Generic.List[string]]::new()
foreach ($e in $existingEntries) { if (-not $allEntries.Contains($e)) { $allEntries.Add($e) } }
foreach ($sid in $desiredSids) {
    $entry = "*$sid"
    if (-not $allEntries.Contains($entry)) { $allEntries.Add($entry) }
}

$newLine = "SeDenyNetworkLogonRight = " + ($allEntries -join ',')

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
Select-String -Path (Join-Path $workDir "verify.cfg") -Pattern "SeDenyNetworkLogonRight"

Remove-Item $workDir -Recurse -Force
