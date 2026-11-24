[CmdletBinding()]
param([ValidateSet('Both', 'Codex', 'OpenCode')][string] $Platform = 'Both', [switch] $Json)
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
. (Join-Path $PSScriptRoot 'Office.Connections.Common.ps1')
$profileRoot = [Environment]::GetFolderPath('UserProfile')
$openProviders = @{
    repository = 'github'; database = 'neon'; web_research = 'browse'
    work_tracking = 'linear'; knowledge = 'notion'; design_source = 'figma'
    communication = 'slack'; observability = 'datadog'; deployment = 'vercel'
    product_analytics = @('mixpanel', 'amplitude')
}
$registryPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'office/capabilities.json'
$catalogue = (Get-Content -LiteralPath $registryPath -Raw | ConvertFrom-Json).capabilities
$report = [Collections.Generic.List[object]]::new()
if ($Platform -ne 'Codex') {
    $cfgRoot = Join-Path $profileRoot '.config/opencode'
    $configured = @{}
    foreach ($file in 'opencode.json', 'opencode.jsonc') {
        $path = Join-Path $cfgRoot $file
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            $cfg = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -AsHashtable
            foreach ($key in $cfg.mcp.servers.Keys) { $configured[$key] = -not $cfg.mcp.servers[$key].disabled }
        }
    }
    $lines = if (Get-Command opencode -ErrorAction SilentlyContinue) { @(& opencode mcp list --standalone 2>$null) }
    foreach ($entry in $catalogue) {
        foreach ($provider in $openProviders[$entry.id]) {
            $status = Get-OfficeConnectionState $provider $lines -Configured:($configured[$provider] -eq $true)
            $report.Add([pscustomobject]@{
                Platform = 'OpenCode'; Capability = $entry.id; Provider = $provider; Status = $status
                Evidence = if ($status -eq 'unverified') { 'Configured globally; CLI did not confirm readiness' } else { 'OpenCode CLI and global config' }
            })
        }
    }
}
if ($Platform -ne 'OpenCode') {
    $codexServers = @()
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        $raw = @(& codex mcp list --json 2>$null)
        if ($LASTEXITCODE -eq 0 -and $raw) { $codexServers = @(($raw -join "`n") | ConvertFrom-Json) }
    }
    foreach ($entry in $catalogue) {
        foreach ($provider in $openProviders[$entry.id]) {
            $configured = @($codexServers | Where-Object { $_.name -ieq $provider -and $_.enabled -ne $false }).Count -gt 0
            $report.Add([pscustomobject]@{
                Platform = 'Codex'; Capability = $entry.id; Provider = $provider
                Status = if ($configured -or $entry.id -in @('repository', 'work_tracking', 'knowledge', 'web_research')) { 'unverified' } else { 'missing' }
                Evidence = if ($configured) { 'Registered in CLI; authentication not tested' } else { 'Desktop apps must be checked in the active session' }
            })
        }
    }
}
if ($Json) { ConvertTo-Json -InputObject $report.ToArray() -Depth 5 } else { $report.ToArray() }
