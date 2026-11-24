[CmdletBinding()]
param(
    [Parameter(Mandatory)][string] $Backup,
    [ValidateSet('Global', 'Project')][string] $Scope = 'Global',
    [string] $Target,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Office.Install.Common.ps1')
$roots = Get-OfficeInstallRoots $Scope $Target
$file = Resolve-OfficeTargetPath $Backup 'manifest.json'
$manifest = Get-Content -LiteralPath $file -Raw | ConvertFrom-Json -AsHashtable
if ($manifest.version -ne 1 -or $manifest.scope -cne $Scope -or $manifest.roots.root -cne $roots.root) {
    throw 'Backup scope or destination differs from the requested installation.'
}
$seen = @{}
$restore = foreach ($entry in $manifest.files) {
    if ($entry.id -cnotmatch '^\d+$' -or -not $roots.ContainsKey($entry.root) -or
        $manifest.roots[$entry.root] -cne $roots[$entry.root]) { throw 'Invalid backup entry.' }
    if ($entry.relative -cnotmatch '^(?:(?:\.config/opencode/|\.opencode/|\.codex/|\.agents/)?AGENTS\.md|(?:\.config/opencode/|\.opencode/)?opencode\.jsonc?|(?:\.config/opencode|\.opencode|\.codex|\.claude)/agents/[a-zA-Z0-9/_.-]+\.(?:md|toml)|\.(?:agents|claude)/skills/[a-z0-9-]+/[a-zA-Z0-9/_.-]+)$') {
        throw 'Backup destination is outside office file locations.'
    }
    $path = Resolve-OfficeTargetPath $roots[$entry.root] $entry.relative
    if ($seen.ContainsKey($path)) { throw "Duplicate backup target '$path'." }
    $seen[$path] = $true
    $current = Get-OfficeFileHash $path
    if ($current -cne $entry.before -and $current -cne $entry.after) {
        throw "Cannot restore over independently modified content: '$path'."
    }
    $copy = $null
    if ($entry.before) {
        $copy = Resolve-OfficeTargetPath $Backup "$($entry.id).bak"
        if ((Get-OfficeFileHash $copy) -cne $entry.before) { throw "Invalid backup bytes in '$copy'." }
    }
    if ($current -cne $entry.before) { [pscustomobject]@{ Path = $path; Copy = $copy; Hash = $entry.before } }
}
if (-not $DryRun) {
    foreach ($entry in $restore) {
        if ($entry.Copy) { Set-OfficeFileBytes $entry.Path ([IO.File]::ReadAllBytes($entry.Copy)) }
        else { Remove-Item -LiteralPath $entry.Path }
        if ((Get-OfficeFileHash $entry.Path) -cne $entry.Hash) { throw "Restore verification failed for '$($entry.Path)'." }
    }
}
[pscustomobject]@{ DryRun = [bool] $DryRun; Files = @($restore.Path) }
