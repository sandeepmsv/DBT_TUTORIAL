# Start terminal activity logging for this DBT project.
# Run this from the project root in PowerShell.
$projectRoot = Get-Location
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$logFile = Join-Path $projectRoot "terminal_history_$timestamp.log"
Start-Transcript -Path $logFile -Force
Write-Host "Terminal logging started. Output is being written to: $logFile"
Write-Host "When finished, run: Stop-Transcript"
