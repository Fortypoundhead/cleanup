<#
.SYNOPSIS
    Deletes old SQL backup (.bak) files from a specified directory.

.DESCRIPTION
    This script removes .bak files older than a defined number of days.
    It helps prevent backup directories from growing too large and consuming
    unnecessary disk space.  It can also be modified to manage other file
    types, such as .log files.  A log file is created/appended for each
    run of the script.

.VERSION
    1.0.0
    - Initial release: basic cleanup of .bak files based on age.

.AUTHOR
    Derek — Senior Windows Systems Engineer / SaaS Architect

.PARAMETER Days
    Number of days to retain backup files.
    Any .bak file older than this threshold will be deleted.
    Default: 30

.PARAMETER Path
    Directory containing .bak files to evaluate and clean up.
    Default: C:\Backups

.EXAMPLE
    .\Cleanup-OldBackups.ps1 -Days 14 -Path "D:\SQLBackups"
    Deletes all .bak files older than 14 days from D:\SQLBackups.

.NOTES
    - This script permanently deletes files. Use caution.
    - Ensure the specified path is correct and accessible.
    - Consider adding -WhatIf for testing before enabling deletion.
#>

param(
    [int]$Days = 30,
    [string]$Path = "C:\Backups"
)

# Log file location

$LogFile = "C:\Backups\CleanupLog.txt"

function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $Message" | Out-File -FilePath $LogFile -Append
}

Write-Log "Starting cleanup. Retention: $Days days. Path: $Path"

$cutoff = (Get-Date).AddDays(-$Days)
Write-Log "Cutoff date calculated as $cutoff"

# Get all .bak files older than the cutoff

$oldFiles = Get-ChildItem -Path $Path -Filter *.bak -File |
            Where-Object { $_.LastWriteTime -lt $cutoff }

Write-Log "Found $($oldFiles.Count) .bak files older than cutoff"

foreach ($file in $oldFiles) {
    Write-Log "Deleting file: $($file.FullName)"
    Remove-Item -Path $file.FullName -Force
}

Write-Log "Cleanup completed"
