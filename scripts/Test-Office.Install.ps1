$ErrorActionPreference = 'Stop'
$installer = Join-Path $PSScriptRoot 'Install-Office.ps1'
$restore = Join-Path $PSScriptRoot 'Restore-Office.ps1'
. (Join-Path $PSScriptRoot 'Office.Install.Common.ps1')
. (Join-Path $PSScriptRoot 'Office.Connections.Common.ps1')
$sandbox = Join-Path ([IO.Path]::GetTempPath()) ('office-install-' + [guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory $sandbox
try {
    $target = (New-Item -ItemType Directory (Join-Path $sandbox 'project')).FullName
    $backupRoot = Join-Path $sandbox 'backups'
    $agents = Join-Path $target 'AGENTS.md'
    $before = "# Local rules`r`n`r`n<!-- equipo-agentes:inicio -->`r`nOld office`r`n<!-- equipo-agentes:fin -->`r`nOriginal footer.`r`n"
    [IO.File]::WriteAllText($agents, $before)
    $config = Join-Path $target 'opencode.jsonc'
    [IO.File]::WriteAllText($config, '{"model":"example/selection","experimental":{"other":true},"mcp":{"servers":{}}}')
    $custom = Join-Path $target '.codex/agents/mine.toml'
    $null = New-Item -ItemType Directory (Split-Path $custom)
    [IO.File]::WriteAllText($custom, '# custom')

    $caught = $null
    try { Resolve-OfficeTargetPath $target '../escape.toml' } catch { $caught = $_.Exception.Message }
    if ($caught -notlike '*Invalid relative*') { throw 'Path traversal was not rejected.' }

    $preview = & $installer -Platform All -Scope Project -Target $target -BackupRoot $backupRoot -DryRun
    if (Test-Path $backupRoot) { throw 'Dry run wrote a backup.' }
    if ($preview.Written.Count -le 61 -or [IO.File]::ReadAllText($agents) -cne $before) { throw 'Invalid dry run.' }
    $result = & $installer -Platform All -Scope Project -Target $target -BackupRoot $backupRoot
    $claudeAgents = @(Get-ChildItem -LiteralPath (Join-Path $target '.claude/agents') -Filter '*.md' -File)
    if ($claudeAgents.Count -ne 31) { throw 'Claude Code roster must contain 31 profiles.' }
    foreach ($file in $claudeAgents) {
        $text = [IO.File]::ReadAllText($file.FullName)
        if (-not $text.StartsWith("---`nname: $($file.BaseName)`n") -or $text -notmatch '(?m)^model: inherit$') {
            throw "Invalid Claude Code metadata in '$($file.Name)'."
        }
    }
    foreach ($id in @('taste-skill', 'referencias-diseno-web')) {
        if (-not (Test-Path -LiteralPath (Join-Path $target ".claude/skills/$id/SKILL.md") -PathType Leaf)) {
            throw "Claude Code is missing skill '$id'."
        }
    }
    $after = [IO.File]::ReadAllText($agents)
    if ($after -notmatch 'Original footer' -or $after -match 'Old office' -or
        [regex]::Matches($after, '<!-- oficina-unificada:inicio -->').Count -ne 1) { throw 'Managed block did not preserve adjacent instructions.' }
    $parsed = Get-Content $config -Raw | ConvertFrom-Json
    if ($parsed.model -cne 'example/selection' -or -not $parsed.experimental.other -or $parsed.experimental.subagent_depth -ne 2) {
        throw 'OpenCode settings were lost.'
    }
    $again = & $installer -Platform All -Scope Project -Target $target -BackupRoot $backupRoot
    if ($again.Written.Count -or $again.Backup) { throw 'Installation is not idempotent.' }
    $profile = Join-Path $target '.codex/agents/frontend.toml'
    $installed = [IO.File]::ReadAllBytes($profile)
    [IO.File]::AppendAllText($profile, '# user edit')
    $caught = $null
    try { & $installer -Platform All -Scope Project -Target $target -BackupRoot $backupRoot } catch { $caught = $_.Exception.Message }
    if ($caught -notlike '*Unexpected content*') { throw 'Modified managed profile was not protected.' }
    [IO.File]::WriteAllBytes($profile, $installed)
    # Simulate a partial install by returning one file to its original bytes.
    [IO.File]::WriteAllText($agents, $before)
    & $restore -Backup $result.Backup -Scope Project -Target $target | Out-Null
    if (([IO.File]::ReadAllText($agents) -cne $before) -or (Test-Path $profile) -or
        (Test-Path -LiteralPath (Join-Path $target '.claude/agents/directora.md')) -or
        (Test-Path -LiteralPath (Join-Path $target '.claude/skills/taste-skill/SKILL.md')) -or
        ([IO.File]::ReadAllText($custom) -cne '# custom')) { throw 'Restore failed to recover original state.' }
    Write-Output 'PASS: dry run, migration, model and unrelated settings preserved, idempotence, conflict and restore'

    $connectionCases = @(
        @{ Line = '✓ github  connected'; Configured = $true; Expect = 'connected' }
        @{ Line = '⚠ github  needs authentication'; Configured = $true; Expect = 'needs_auth' }
        @{ Line = '○ github  disabled'; Configured = $true; Expect = 'missing' }
        @{ Line = 'No MCP servers configured'; Configured = $true; Expect = 'unverified' }
        @{ Line = '✓ github-enterprise  connected'; Configured = $false; Expect = 'missing' }
    )
    foreach ($case in $connectionCases) {
        if ((Get-OfficeConnectionState github $case.Line -Configured:$case.Configured) -cne $case.Expect) {
            throw "Incorrect MCP status for '$($case.Line)'."
        }
    }
    Write-Output 'PASS: live status, authentication, disabled and unavailable connection evidence distinguished'
} finally {
    $resolved = (Resolve-Path -LiteralPath $sandbox).Path
    $temp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('/', '\') + [IO.Path]::DirectorySeparatorChar
    if (-not $resolved.StartsWith($temp, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe test cleanup path.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
