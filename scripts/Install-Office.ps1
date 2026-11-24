[CmdletBinding()]
param(
    [ValidateSet('Both', 'All', 'Codex', 'OpenCode', 'Claude')][string] $Platform = 'Both',
    [ValidateSet('Global', 'Project')][string] $Scope = 'Global',
    [string] $Target,
    [string] $BackupRoot,
    [switch] $DryRun,
    [switch] $Force
)
$ErrorActionPreference = 'Stop'
$kitRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'Office.Install.Common.ps1')
& (Join-Path $PSScriptRoot 'Build-Office.ps1') -Platform $Platform -Check | Out-Null
$roots = Get-OfficeInstallRoots $Scope $Target
$utf8 = [Text.UTF8Encoding]::new($false, $true)
$inventory = Get-Content -LiteralPath (Join-Path $kitRoot 'office/legacy-files.json') -Raw | ConvertFrom-Json -AsHashtable
$registry = Get-OfficeRegistry $kitRoot
$codex = $Platform -in @('Codex', 'Both', 'All')
$openCode = $Platform -in @('OpenCode', 'Both', 'All')
$claude = $Platform -in @('Claude', 'All')
$changes = [ordered]@{}
$globalScope = $Scope -eq 'Global'
$openPrefix = if ($globalScope) { '.config/opencode' } else { '.opencode' }

function Add-OfficeChange {
    param([string] $Root, [string] $Relative, [byte[]] $Bytes, [string[]] $KnownHash, [switch] $Merge)
    $path = Resolve-OfficeTargetPath $roots[$Root] $Relative
    $before = Get-OfficeFileHash $path
    $after = if ($null -ne $Bytes) { Get-OfficeBytesHash $Bytes } else { $null }
    if ($before -ceq $after) { return }
    if (-not $Merge -and $before -and $before -cnotin $KnownHash -and -not $Force) {
        throw "Unexpected content at '$path'. Review the file before using -Force."
    }
    $changes[$path] = [pscustomobject]@{
        Path = $path; Root = $Root; Relative = $Relative; Before = $before; After = $after; Bytes = $Bytes
    }
}

function Add-OfficeInstructions {
    param([string] $Root, [string] $Relative, [string] $DirectorBlock)
    $path = Resolve-OfficeTargetPath $roots[$Root] $Relative
    $exists = Test-Path -LiteralPath $path -PathType Leaf
    if (-not $exists -and -not $DirectorBlock) { return }
    $text = if ($exists) { [IO.File]::ReadAllText($path, $utf8) } else { '' }
    $updated = Remove-LegacyOfficeBlock $text
    if ($DirectorBlock) { $updated = Set-ManagedInstructionBlock $updated $DirectorBlock }
    if ($updated -cne $text) { Add-OfficeChange $Root $Relative $utf8.GetBytes($updated) -Merge }
}

$legacy = if ($globalScope) { $inventory.global } else { $inventory.project }
foreach ($role in $registry.profiles) {
    if ($codex -and $role.kind -ne 'director') {
        $relative = ".codex/agents/$($role.id).toml"
        Add-OfficeChange root $relative ([IO.File]::ReadAllBytes((Join-Path $kitRoot $relative))) $legacy[$relative]
    }
    if ($openCode) {
        $relative = "$openPrefix/agents/$($role.id).md"
        $source = Join-Path $kitRoot ".opencode/agents/$($role.id).md"
        Add-OfficeChange root $relative ([IO.File]::ReadAllBytes($source)) $legacy[$relative]
    }
    if ($claude) {
        $relative = ".claude/agents/$($role.id).md"
        Add-OfficeChange root $relative ([IO.File]::ReadAllBytes((Join-Path $kitRoot $relative)))
    }
}

$installedIds = @($registry.profiles.id)
foreach ($relative in $legacy.Keys) {
    $isOpenAgent = $relative.StartsWith("$openPrefix/agents/")
    $isCodexAgent = $relative.StartsWith('.codex/agents/')
    if (($openCode -and $isOpenAgent) -or ($codex -and $isCodexAgent)) {
        $path = Resolve-OfficeTargetPath $roots.root $relative
        $id = [IO.Path]::GetFileNameWithoutExtension($relative)
        if (-not $changes.Contains($path) -and ($id -notin $installedIds -or $relative.StartsWith("$openPrefix/agents/oficina/"))) {
            Add-OfficeChange root $relative $null $legacy[$relative]
        }
    }
}

$skillIds = @($registry.profiles.skills | Where-Object { $_ } | Sort-Object -Unique)
$skillTargets = @()
if ($codex -or $openCode) { $skillTargets += '.agents/skills' }
if ($claude) { $skillTargets += '.claude/skills' }
foreach ($id in $skillIds) {
    $source = Join-Path $kitRoot "skills/$id"
    if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) { throw "Missing skill '$id'." }
    foreach ($file in Get-ChildItem -LiteralPath $source -File -Recurse) {
        $suffix = [IO.Path]::GetRelativePath($source, $file.FullName).Replace('\', '/')
        foreach ($destination in $skillTargets) {
            $relative = "$destination/$id/$suffix"
            Add-OfficeChange root $relative ([IO.File]::ReadAllBytes($file.FullName)) $legacy[$relative]
        }
    }
}

if ($codex) {
    $director = $registry.profiles | Where-Object kind -eq 'director'
    $template = [IO.File]::ReadAllText((Join-Path $kitRoot 'templates/AGENTS-oficina.md'))
    $block = $template.Replace('{{DIRECTOR_PROMPT}}', (Get-OfficeRolePrompt $director $kitRoot).TrimEnd("`r", "`n"))
    $instructionPath = if ($globalScope) { '.codex/AGENTS.md' } else { 'AGENTS.md' }
    Add-OfficeInstructions root $instructionPath $block
}
if ($openCode) {
    if ($globalScope) { Add-OfficeInstructions root "$openPrefix/AGENTS.md" }
    $configDir = if ($globalScope) { "$openPrefix/" } else { '' }
    $candidates = @("${configDir}opencode.json", "${configDir}opencode.jsonc")
    if (-not $globalScope) { $candidates += @('.opencode/opencode.json', '.opencode/opencode.jsonc') }
    $existing = @($candidates | Where-Object {
        $candidatePath = Resolve-OfficeTargetPath $roots.root $_
        Test-Path -LiteralPath $candidatePath -PathType Leaf
    })
    if ($existing.Count -gt 1) { throw 'Multiple OpenCode configuration files exist at the target. Resolve precedence before installing.' }
    $relative = if ($existing.Count) { $existing[0] } else { "${configDir}opencode.jsonc" }
    $path = Resolve-OfficeTargetPath $roots.root $relative
    try {
        $config = if ($existing.Count) { [IO.File]::ReadAllText($path, $utf8) | ConvertFrom-Json -AsHashtable }
            else { [ordered]@{ '$schema' = 'https://opencode.ai/config.json' } }
    } catch { throw "Unable to parse OpenCode configuration at '$path'." }
    if ($config -isnot [Collections.IDictionary]) { throw 'Invalid OpenCode configuration object.' }
    if (-not $config.Contains('experimental')) { $config.experimental = [ordered]@{} }
    if ($config.experimental -isnot [Collections.IDictionary]) { throw 'Invalid OpenCode experimental configuration.' }
    if ($config.default_agent -cne 'directora' -or $config.experimental.subagent_depth -ne 2) {
        $config.default_agent = 'directora'
        $config.experimental.subagent_depth = 2
        Add-OfficeChange root $relative $utf8.GetBytes(($config | ConvertTo-Json -Depth 100) + "`n") -Merge
    }
}

$plan = @($changes.Values)
$backup = $null
if (-not $DryRun -and $plan.Count) {
    if (-not $BackupRoot) { $BackupRoot = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.office-backups' }
    $backup = Backup-OfficeChanges $BackupRoot $Scope $roots $plan
    try {
        foreach ($item in $plan) {
            if ((Get-OfficeFileHash $item.Path) -cne $item.Before) { throw "Concurrent modification of '$($item.Path)'." }
            if ($item.After) { Set-OfficeFileBytes $item.Path $item.Bytes }
            else { Remove-Item -LiteralPath $item.Path }
        }
        foreach ($item in $plan) {
            if ((Get-OfficeFileHash $item.Path) -cne $item.After) { throw "Installation verification failed for '$($item.Path)'." }
        }
    } catch {
        $failure = $_
        try { & (Join-Path $PSScriptRoot 'Restore-Office.ps1') -Backup $backup -Scope $Scope -Target $Target | Out-Null }
        catch { throw "Installation interrupted. Restore could not finish. Backup: '$backup'. $($_.Exception.Message)" }
        throw "Installation rolled back. Backup: '$backup'. $($failure.Exception.Message)"
    }
}
[pscustomobject]@{
    Platform = $Platform; Scope = $Scope; DryRun = [bool] $DryRun; Backup = $backup
    Written = @($plan | Where-Object After | ForEach-Object Path)
    Removed = @($plan | Where-Object { -not $_.After } | ForEach-Object Path)
}
