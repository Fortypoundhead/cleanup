$taskName   = "CleanupOldBackups"
$scriptPath = "C:\Admin\Scripts\Clean-Backups.ps1"

# Run daily at 2:00 AM
$trigger = New-ScheduledTaskTrigger -Daily -At 2:00am

# Run with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Action: execute PowerShell with your script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File '"$scriptPath'""

# Register the task
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Principal $principal
