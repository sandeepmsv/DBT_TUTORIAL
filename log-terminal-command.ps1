param(
    [string]$ReadmePath = "README.md"
)

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$command = $MyInvocation.Line.Trim()
$projectRoot = (Get-Location).Path
$readmeFullPath = Join-Path $projectRoot $ReadmePath

if (-not (Test-Path $readmeFullPath)) {
    throw "README not found at $readmeFullPath"
}

$entry = "- [$timestamp] `"$command`""
$marker = "## Command Log Summary"
$readme = Get-Content $readmeFullPath -Raw

if ($readme -notmatch "## Command Log Summary") {
    throw "README does not contain the '## Command Log Summary' section"
}

$sectionPattern = "(?ms)## Command Log Summary.*?## Detailed Technical Explanation"
$replacement = "## Command Log Summary`n`nThe following commands have been used during this session and should be treated as the working workflow for the project:`n`n```powershell`n$entry`n```n`n## Detailed Technical Explanation"

if ($readme -match $sectionPattern) {
    $updated = [regex]::Replace($readme, $sectionPattern, $replacement, 1)
} else {
    $updated = $readme
}

Set-Content -Path $readmeFullPath -Value $updated -NoNewline
Write-Host "Appended command to README: $command"
