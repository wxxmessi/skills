<#
.SYNOPSIS
    Sync local asset/project repos to their GitHub remotes in one command.

.DESCRIPTION
    Generic sync script for any of the 6 personal repos (E:\知识库, E:\记忆,
    E:\技能, E:\技能-私人, E:\投资Lab, E:\投资Lab代码). Verifies the repo,
    stages all changes, commits with the supplied (or auto-generated) message,
    and pushes to origin/main.

.PARAMETER Path
    Local repo path. Required unless -All is specified.

.PARAMETER Message
    Commit message. Defaults to "更新: <yyyy-MM-dd HH:mm>".

.PARAMETER All
    Sync all 6 known repos in sequence.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File sync-asset.ps1 -Path E:\知识库
    powershell -ExecutionPolicy Bypass -File sync-asset.ps1 -Path E:\记忆 -Message "新增决策记录"
    powershell -ExecutionPolicy Bypass -File sync-asset.ps1 -All
#>

[CmdletBinding(DefaultParameterSetName='Single')]
param(
    [Parameter(ParameterSetName='Single', Position=0)]
    [string]$Path,

    [Parameter(ParameterSetName='Single')]
    [string]$Message,

    [Parameter(ParameterSetName='All')]
    [switch]$All
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$KnownRepos = @(
    'E:\知识库',
    'E:\记忆',
    'E:\技能',
    'E:\技能-私人',
    'E:\投资Lab',
    'E:\投资Lab代码'
)

function Write-Step([string]$Text) {
    Write-Host ''
    Write-Host "==> $Text" -ForegroundColor Cyan
}

function Sync-OneRepo {
    param(
        [Parameter(Mandatory)][string]$RepoPath,
        [string]$CommitMessage
    )

    Write-Host ''
    Write-Host "########## $RepoPath ##########" -ForegroundColor Magenta

    if (-not (Test-Path $RepoPath)) {
        Write-Warning "Path not found, skip: $RepoPath"
        return $false
    }

    if (-not (Test-Path (Join-Path $RepoPath '.git'))) {
        Write-Warning "Not a git repo (missing .git), skip: $RepoPath"
        return $false
    }

    Push-Location $RepoPath
    try {
        Write-Step 'git status'
        git status --short
        if ($LASTEXITCODE -ne 0) { throw "git status failed in $RepoPath" }

        $pending = git status --porcelain
        if ([string]::IsNullOrWhiteSpace($pending)) {
            Write-Host 'Working tree clean.' -ForegroundColor Green
            Write-Step 'git push (in case of unpushed commits)'
            git push 2>&1 | Out-Host
            return $true
        }

        if (-not $CommitMessage) {
            $CommitMessage = '更新: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
        }

        Write-Step 'git add .'
        git add .
        if ($LASTEXITCODE -ne 0) { throw "git add failed in $RepoPath" }

        Write-Step "git commit -m `"$CommitMessage`""
        git commit -m $CommitMessage
        if ($LASTEXITCODE -ne 0) { throw "git commit failed in $RepoPath" }

        Write-Step 'git push'
        git push
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Push failed in $RepoPath. Try: git pull --rebase ; then re-run."
            return $false
        }

        Write-Host "[OK] $RepoPath synced." -ForegroundColor Green
        return $true
    } finally {
        Pop-Location
    }
}

if ($All) {
    $results = @()
    foreach ($r in $KnownRepos) {
        $ok = Sync-OneRepo -RepoPath $r -CommitMessage $Message
        $results += [PSCustomObject]@{ Repo = $r; Synced = $ok }
    }
    Write-Host ''
    Write-Host '========== Summary ==========' -ForegroundColor Cyan
    $results | Format-Table -AutoSize
} else {
    if (-not $Path) {
        Write-Error 'Either -Path <repo> or -All is required.'
        exit 1
    }
    $ok = Sync-OneRepo -RepoPath $Path -CommitMessage $Message
    if (-not $ok) { exit 1 }
}
