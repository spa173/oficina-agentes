# Classify from explicit runtime evidence, not from the presence of a server entry.
function Get-OfficeConnectionState {
    param([string] $Provider, [string[]] $StatusLines, [switch] $Configured)
    $prefix = '^\s*(?:[✓✗○●!◇◆×✘⚠]\s+)?' + [regex]::Escape($Provider) + '(?:\s{2,}|\s*[:–-]\s*|\s+)'
    foreach ($line in $StatusLines) {
        if ($line -notmatch ($prefix + '(?<state>needs authentication|connected|disabled|failed|disconnected|not connected)\b')) { continue }
        $state = $Matches.state.ToLowerInvariant()
        switch ($state) {
            'connected' { return 'connected' }
            'needs authentication' { return 'needs_auth' }
            default { return 'missing' }
        }
    }
    if ($Configured) { return 'unverified' }
    'missing'
}
