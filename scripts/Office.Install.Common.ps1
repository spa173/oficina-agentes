. (Join-Path $PSScriptRoot 'Office.Common.ps1')

function Resolve-OfficeTargetPath {
    param([string] $Base, [string] $RelativePath)
    $parts = $RelativePath -split '[/\\]'
    if ($parts.Where({ $_ -in '', '.', '..' -or $_ -match '[<>:"|?*\x00-\x1f]' -or $_ -match '[ .]$' }).Count) {
        throw "Invalid relative office path '$RelativePath'."
    }
    $path = [IO.Path]::GetFullPath($Base)
    foreach ($part in $parts) {
        $path = Join-Path $path $part
        $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
        if ($null -ne $item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Office target is a symlink or junction: '$path'."
        }
    }
    $path
}

function Get-OfficeInstallRoots {
    param([string] $Scope, [string] $Target)
    $base = [Environment]::GetFolderPath('UserProfile')
    if ($Scope -eq 'Project') {
        if (-not $Target) { throw 'Specify an existing project directory with -Target.' }
        $base = (Get-Item -LiteralPath $Target -ErrorAction Stop).FullName
    } elseif ($Target) { throw '-Target applies only to Project scope.' }
    $item = Get-Item -LiteralPath $base -Force
    if (-not $item.PSIsContainer -or $item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw 'The installation root must be a regular directory.'
    }
    @{ root = $item.FullName }
}

function Get-OfficeFileHash {
    param([string] $Path)
    if (Test-Path -LiteralPath $Path -PathType Leaf) { (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash }
    elseif (Test-Path -LiteralPath $Path) { throw "Expected a file at '$Path'." }
    else { $null }
}

function Get-OfficeBytesHash {
    param([byte[]] $Bytes)
    [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes))
}

function Remove-LegacyOfficeBlock {
    param([string] $Text)
    $start = '<!-- equipo-agentes:inicio -->'
    $end = '<!-- equipo-agentes:fin -->'
    $a = [regex]::Matches($Text, [regex]::Escape($start))
    $b = [regex]::Matches($Text, [regex]::Escape($end))
    if ($a.Count -ne $b.Count -or $a.Count -gt 1 -or ($a.Count -and $a[0].Index -ge $b[0].Index)) {
        throw 'Invalid legacy office markers in AGENTS.md.'
    }
    if (-not $a.Count) { return $Text }
    $Text.Remove($a[0].Index, $b[0].Index + $end.Length - $a[0].Index)
}

function Set-OfficeFileBytes {
    param([string] $Path, [byte[]] $Bytes)
    $dir = Split-Path -Parent $Path
    $null = New-Item -ItemType Directory -Path $dir -Force
    $tempFile = Join-Path $dir ('.office-' + [guid]::NewGuid().ToString('N') + '.tmp')
    try {
        [IO.File]::WriteAllBytes($tempFile, $Bytes)
        [IO.File]::Move($tempFile, $Path, $true)
    } finally {
        if (Test-Path -LiteralPath $tempFile -PathType Leaf) { Remove-Item -LiteralPath $tempFile }
    }
}

function Backup-OfficeChanges {
    param([string] $BackupRoot, [string] $Scope, [hashtable] $Roots, [object[]] $Changes)
    $path = Join-Path $BackupRoot ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    $null = New-Item -ItemType Directory -Path $path
    $manifest = [ordered]@{ version = 1; scope = $Scope; roots = $Roots; files = @() }
    foreach ($change in $Changes) {
        $id = [string] $manifest.files.Count
        if ($change.Before) {
            $copy = Join-Path $path "$id.bak"
            [IO.File]::Copy($change.Path, $copy)
            if ((Get-OfficeFileHash $copy) -cne $change.Before) {
                throw "File changed while backing up '$($change.Path)'. No installation writes were made."
            }
        }
        $manifest.files += [ordered]@{
            id = $id; root = $change.Root; relative = $change.Relative
            before = $change.Before; after = $change.After
        }
    }
    [IO.File]::WriteAllText((Join-Path $path 'manifest.json'), ($manifest | ConvertTo-Json -Depth 8))
    $path
}
