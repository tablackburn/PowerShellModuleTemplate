# Resolve host paths for cross-platform devcontainer bind mounts.
# Writes .devcontainer/.env for docker-compose variable substitution.
# This runs on the HOST via initializeCommand before the container is created.

$claudeHome = if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($env:HOME) { $env:HOME } else { $null }

if (-not $claudeHome) {
    Write-Warning 'Could not detect host home directory (neither USERPROFILE nor HOME is set).'
    Write-Warning 'Claude Code config bind mounts will not be available in the devcontainer.'
    return
}

# Resolve the workspace folder (parent of .devcontainer/)
$workspace = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$workspaceName = Split-Path $workspace -Leaf

# Normalize to forward slashes for Docker bind mount compatibility on Windows
$claudeHome = $claudeHome -replace '\\', '/'
$workspace = $workspace -replace '\\', '/'

$envContent = @"
CLAUDE_HOST_HOME="$claudeHome"
LOCAL_WORKSPACE_FOLDER="$workspace"
LOCAL_WORKSPACE_FOLDER_BASENAME="$workspaceName"
"@

$envPath = Join-Path $PSScriptRoot '.env'
Set-Content -Path $envPath -Value $envContent
Write-Host "Wrote devcontainer .env to $envPath"
