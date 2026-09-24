# Windows 11 STIG Remediations

PowerShell scripts that remediate select findings from the DISA Microsoft Windows 11 STIG. Each script follows a standard header format (`.SYNOPSIS` / `.NOTES` with STIG-ID and documentation link / `.TESTED ON` / `.USAGE`) and is designed to be run directly on a test VM.

## Usage

```powershell
.\<STIG-ID>.ps1
```

Run in an elevated PowerShell session.

## Scripts

| STIG-ID | Remediation |
|---|---|
| WN11-AU-000500 | Configure the Application event log size to 32768 KB or greater |
| WN11-CC-000040 | Disable insecure logons to an SMB server |
| WN11-CC-000068 | Configure "Remote host allows delegation of non-exportable credentials" |
| WN11-CC-000110 | Prevent printing over HTTP |
| WN11-CC-000206 | Prevent Windows Update from obtaining updates from other PCs on the internet |
| WN11-CC-000252 | Disable Windows Game Recording and Broadcasting |
| WN11-CC-000270 | Prevent passwords from being saved in the Remote Desktop Client |
| WN11-CC-000345 | Disable Basic authentication for the Windows Remote Management (WinRM) service |
| WN11-SO-000070 | Set machine inactivity limit to 15 minutes, locking with the screensaver |
| WN11-SO-000190 | Configure Kerberos encryption types to prevent DES and RC4 |
| WN11-UR-000070 | Configure "Deny access to this computer from the network" to block highly privileged/local accounts and unauthenticated access |
| WN11-UR-000160 | Restrict the "Restore files and directories" user right to Administrators |

## Disclaimer

These scripts remediate individual STIG findings for lab/training purposes and are not a substitute for a full STIG compliance scan or organizational hardening process.
