<#
.SYNOPSIS
    单向同步 Cursor 运行时 canvas 副本到 git 归档目录。

.DESCRIPTION
    Cursor 在 IDE 内创建的 *.canvas.tsx 默认存放在工作区元数据目录：
      C:\Users\<user>\.cursor\projects\<workspace>\canvases\
    这个目录不在任何 git 仓里，重装 / 清缓存 / 切电脑可能丢失。

    本脚本按白名单把它们镜像到两个 git 仓的归档目录：
      - 通用知识：E:\知识库\canvases\          （wxxmessi/foundry, private）
      - 公司项目：E:\技能-私人\company-canvases\（wxxmessi/private, private）
      - 个人兴趣 / 草稿：默认跳过

    单向：运行时副本 -> 归档目录（IDE 编辑总是改运行时副本，本脚本不反向覆盖）。

.PARAMETER DryRun
    只打印将要做什么，不实际复制。

.PARAMETER Source
    指定运行时副本目录（默认 C:\Users\<user>\.cursor\projects\e\canvases）。

.EXAMPLE
    E:\技能\cursor\scripts\sync-canvases.ps1
    E:\技能\cursor\scripts\sync-canvases.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [string]$Source = "$env:USERPROFILE\.cursor\projects\e\canvases"
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ====== 白名单 ======

# 镜像到 E:\知识库\canvases\（wxxmessi/foundry，private；变量名 Public 仅指"通用知识库"）
$PublicTargets = @(
    'rag-overview.canvas.tsx',
    'agent-memory-systems.canvas.tsx',
    'qc-dialogue-insight-features.canvas.tsx',
    'agent-tag-system-design.canvas.tsx',
    'investment-agent-learning-plan.canvas.tsx',
    'gui-agent-toolchain-recommendation.canvas.tsx',
    'personal-ai-stack-design.canvas.tsx',
    'spain-worldcup-2026.canvas.tsx',
    'worldcup-2026-overview.canvas.tsx',
    '质检平台产品全景.canvas.tsx'
)

# 镜像到 E:\技能-私人\company-canvases\（wxxmessi/private，含公司信息）
$PrivateOnly = @(
    'xinfei-vqc-product-analysis.canvas.tsx'
)

# 显式跳过（不入任何仓）
$Skip = @()

$PublicDest  = 'E:\知识库\canvases'
$PrivateDest = 'E:\技能-私人\company-canvases'

# ====== 校验 ======

if (-not (Test-Path $Source)) {
    Write-Host "[ERR] 源目录不存在: $Source" -ForegroundColor Red
    exit 1
}

foreach ($d in @($PublicDest, $PrivateDest)) {
    if (-not (Test-Path $d)) {
        if ($DryRun) {
            Write-Host "[DRY] would mkdir: $d" -ForegroundColor Yellow
        } else {
            New-Item -Path $d -ItemType Directory -Force | Out-Null
            Write-Host "[NEW] $d" -ForegroundColor Green
        }
    }
}

# ====== 执行同步 ======

$mode = if ($DryRun) { '[DRY-RUN]' } else { '[EXEC]' }
Write-Host "$mode source = $Source" -ForegroundColor Cyan
Write-Host ""

function Mirror-One {
    param([string]$File, [string]$Dest, [string]$Tag)
    $from = Join-Path $Source $File
    $to   = Join-Path $Dest $File
    if (-not (Test-Path $from)) {
        Write-Host "  [MISS]   $Tag  $File" -ForegroundColor DarkGray
        return $null
    }
    $srcInfo = Get-Item $from
    $changed = $true
    if (Test-Path $to) {
        $dstInfo = Get-Item $to
        if ($srcInfo.Length -eq $dstInfo.Length -and $srcInfo.LastWriteTime -le $dstInfo.LastWriteTime) {
            $changed = $false
        }
    }
    if (-not $changed) {
        Write-Host "  [SKIP]   $Tag  $File (no change)" -ForegroundColor DarkGray
        return $null
    }
    if ($DryRun) {
        Write-Host "  [WOULD]  $Tag  $File -> $to" -ForegroundColor Yellow
    } else {
        Copy-Item $from $to -Force
        Write-Host "  [SYNC]   $Tag  $File" -ForegroundColor Green
    }
    return $File
}

Write-Host "--- public (E:\知识库\canvases) ---" -ForegroundColor Cyan
$pubSynced = @()
foreach ($f in $PublicTargets) {
    $r = Mirror-One -File $f -Dest $PublicDest -Tag 'pub'
    if ($r) { $pubSynced += $r }
}

Write-Host ""
Write-Host "--- private (E:\技能-私人\company-canvases) ---" -ForegroundColor Cyan
$prvSynced = @()
foreach ($f in $PrivateOnly) {
    $r = Mirror-One -File $f -Dest $PrivateDest -Tag 'prv'
    if ($r) { $prvSynced += $r }
}

Write-Host ""
Write-Host "--- skipped ---" -ForegroundColor Cyan
foreach ($f in $Skip) {
    if (Test-Path (Join-Path $Source $f)) {
        Write-Host "  [SKIP]   skp  $f (in `$Skip list)" -ForegroundColor DarkGray
    }
}

# ====== 检测孤儿（运行时新增、白名单未覆盖）======

Write-Host ""
Write-Host "--- orphans (未登记到 public/private/skip 的 canvas) ---" -ForegroundColor Cyan
$known = $PublicTargets + $PrivateOnly + $Skip
$found = Get-ChildItem -Path $Source -Filter "*.canvas.tsx" -ErrorAction SilentlyContinue
$orphans = @()
foreach ($f in $found) {
    if ($f.Name -notin $known) {
        $orphans += $f.Name
        Write-Host "  [ORPH]   $($f.Name)  ($([math]::Round($f.Length/1KB,1)) KB, $($f.LastWriteTime.ToString('yyyy-MM-dd')))" -ForegroundColor Magenta
    }
}
if ($orphans.Count -eq 0) {
    Write-Host "  (none)" -ForegroundColor DarkGray
} else {
    Write-Host ""
    Write-Host "  [TIP] 把孤儿加入 sync-canvases.ps1 的 `$PublicTargets / `$PrivateOnly / `$Skip 三者之一" -ForegroundColor Yellow
}

# ====== 总结 ======

Write-Host ""
Write-Host "=== 总结 ===" -ForegroundColor Cyan
Write-Host "  public  synced: $($pubSynced.Count) / $($PublicTargets.Count)" -ForegroundColor White
Write-Host "  private synced: $($prvSynced.Count) / $($PrivateOnly.Count)" -ForegroundColor White
Write-Host "  orphans       : $($orphans.Count)" -ForegroundColor White

if (-not $DryRun -and ($pubSynced.Count + $prvSynced.Count) -gt 0) {
    Write-Host ""
    Write-Host "  下一步: 进入两个仓 git add/commit/push" -ForegroundColor Yellow
    if ($pubSynced.Count -gt 0) {
        Write-Host "    cd E:\知识库 ; git add canvases ; git commit -m 'sync: canvases' ; git push" -ForegroundColor DarkGray
    }
    if ($prvSynced.Count -gt 0) {
        Write-Host "    cd E:\技能-私人 ; git add company-canvases ; git commit -m 'sync: canvases' ; git push" -ForegroundColor DarkGray
    }
}
