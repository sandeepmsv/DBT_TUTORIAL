$projectRoot = "c:\Users\sande\OneDrive\Documents\DBT_TUTORIAL"
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$logPath = Join-Path $projectRoot "terminal_history_$timestamp.log"

Start-Transcript -Path $logPath -Force | Out-Null
Write-Host "Automatic terminal capture started. Log: $logPath"

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    Stop-Transcript | Out-Null
} | Out-Null
