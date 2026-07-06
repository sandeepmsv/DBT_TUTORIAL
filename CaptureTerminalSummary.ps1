$projectRoot = "c:\Users\sande\OneDrive\Documents\DBT_TUTORIAL"
$readmePath = Join-Path $projectRoot "README.md"
$logDir = Join-Path $projectRoot "terminal_logs"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$logFile = Join-Path $logDir "terminal_$timestamp.log"

Start-Transcript -Path $logFile -Force | Out-Null
Write-Host "Auto capture started. Logging to $logFile"

$lastSummary = $null

while ($true) {
    Start-Sleep -Seconds 120
    $summary = Get-Content $logFile -Tail 80 -ErrorAction SilentlyContinue
    if ($summary) {
        $important = $summary | Where-Object {
            $_ -match 'dbt|uv|python|Activate|clean|debug|error|warning|success|failed|completed|Running with dbt|Using profiles|Connection|catalog|schema|auth_type|personal_access_token'
        }
        if ($important -and ($lastSummary -ne ($important -join "`n"))) {
            $lastSummary = $important -join "`n"
            $readme = Get-Content $readmePath -Raw
            $marker = "## Important Terminal Notes"
            if ($readme -notmatch [regex]::Escape($marker)) {
                $readme = $readme + "`n`n## Important Terminal Notes`n"
            }
            $entry = "`n`n- $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n```text`n$lastSummary`n```"
            $readme = $readme -replace [regex]::Escape("## Important Terminal Notes"), "## Important Terminal Notes$entry"
            Set-Content -Path $readmePath -Value $readme -NoNewline
        }
    }
}
