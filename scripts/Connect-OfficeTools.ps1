[CmdletBinding()]
param(
    [Parameter(Mandatory)][string] $Capability,
    [ValidateSet('Codex', 'OpenCode')][string] $Platform = 'Codex',
    [ValidateSet('Mixpanel', 'Amplitude')][string] $AnalyticsProvider,
    [switch] $DryRun
)
$kit = Split-Path -Parent $PSScriptRoot
$catalogue = (Get-Content -LiteralPath (Join-Path $kit 'office/capabilities.json') -Raw | ConvertFrom-Json).capabilities
$entry = $catalogue | Where-Object id -ceq $Capability
if (-not $entry) { throw "Unknown capability '$Capability'." }
$provider = $entry.providers -join ' / '
if ($Capability -eq 'product_analytics') {
    if (-not $AnalyticsProvider) { throw 'Choose Mixpanel or Amplitude with -AnalyticsProvider.' }
    $provider = $AnalyticsProvider
}
$instructions = if ($Platform -eq 'OpenCode') {
    'Use /mcps to inspect existing connections. For a configured remote server, select it and authenticate when prompted. Add only the official endpoint for the selected service.'
} else {
    'Open Codex Plugins, select the provider, and connect the intended account. For a standalone MCP, use codex mcp add --help and the provider documentation.'
}
if ($Capability -eq 'web_research') {
    $instructions = 'Check native web search or fetch with a public page before adding a browser MCP.'
}
[pscustomobject]@{ Capability = $Capability; Platform = $Platform; Provider = $provider; Action = $instructions }
