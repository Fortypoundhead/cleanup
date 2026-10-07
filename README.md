# Backup Cleanup & Scheduled Task Automation

This repository contains two PowerShell scripts designed to automate SQL backup maintenance and ensure cleanup runs reliably on a schedule.

## Overview

Managing SQL backup directories can become unwieldy over time, especially when .bak files accumulate unchecked. This repo provides:

- Clean-Backups.ps1 — A parameterized cleanup script that deletes .bak files older than a specified number of days and logs each run.
- Register-Task.ps1 — A script that registers a Windows Scheduled Task to run the cleanup automatically every day at 2:00 AM under SYSTEM privileges.

Together, these scripts provide a lightweight, production-ready maintenance workflow for SQL backup directories.

## Scripts

### Clean-Backups.ps1

A robust cleanup script with logging and configurable retention.

### Features

- Deletes .bak files older than a specified number of days
- Logs every action to CleanupLog.txt
- Easily adaptable to other file types (e.g., .log)
- Safe, predictable behavior with clear output

### Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| Days | Number of days to retain backup files | 30 |
| Path | Directory containing .bak files | C:\Backups |

### Logging

A log file is created or appended at:

```C:\Backups\CleanupLog.txt```

Each run records:

- Start time
- Retention settings
- Cutoff date
- Number of files found
- Each deletion
- Completion status

### Example Usage

```powershell
.\Clean-Backups.ps1 -Days 14 -Path "D:\SQLBackups"
```

## Register-Task.ps1

Registers a Windows Scheduled Task that runs the cleanup script daily.

### Task Details

- Task Name: CleanupOldBackups
- Runs As: SYSTEM (highest privileges)
- Schedule: Daily at 2:00 AM
- Action: Executes PowerShell silently with your cleanup script

### Script Behavior

The script:

- Creates a daily trigger
- Configures SYSTEM as the principal
- Registers the scheduled task
- Points to your cleanup script at:

```C:\Admin\Scripts\Clean-Backups.ps1```

### Example

```powershell.exe -File .\Register-Task.ps1```

## Notes

- Cleanup is permanent — verify your path and retention settings.
- Consider adding -WhatIf during testing.
- Ensure the log directory exists before running the script
- SYSTEM-level scheduled tasks require administrative privileges
