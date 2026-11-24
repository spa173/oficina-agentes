function ConvertTo-ClaudeAgent {
    param([pscustomobject] $Role, [string] $Prompt, [string[]] $Children)

    $tools = @('Read', 'Glob', 'Grep', 'Skill')
    if ($Role.permission_set -ne 'readonly') { $tools += @('Edit', 'Write', 'Bash') }
    if ($Role.id -eq 'qa') { $tools += 'Bash' }
    if ('web_research' -cin $Role.capabilities) { $tools += @('WebSearch', 'WebFetch') }
    if ($Children.Count) { $tools += "Agent($($Children -join ', '))" }
    @(
        '---'
        "name: $($Role.id)"
        "description: $(ConvertTo-Json -InputObject $Role.description -Compress)"
        'model: inherit'
        "tools: $(ConvertTo-Json -InputObject $tools -Compress)"
        '---'
        ''
        "<!-- GENERATED: DO NOT EDIT. Sources: office/registry.json; $($Role.prompt). -->"
        ''
        ($Prompt -replace "`r`n?", "`n").TrimEnd("`n")
        ''
    ) -join "`n"
}
