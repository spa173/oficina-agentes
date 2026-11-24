[CmdletBinding()]
param([Parameter(Mandatory)][string] $Target, [switch] $Force, [switch] $DryRun)

Write-Warning 'Install-Equipo.ps1 is deprecated. Use Install-Office.ps1 -Scope Project.'
& (Join-Path $PSScriptRoot 'Install-Office.ps1') -Scope Project -Target $Target -Force:$Force -DryRun:$DryRun
