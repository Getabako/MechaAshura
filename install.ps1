# メカアシュラ君 — one-line installer (Windows)
#
#   iwr -useb https://raw.githubusercontent.com/Getabako/MechaAshura/main/install.ps1 | iex
#
# 何度貼ってもOK。デスクトップに MechaAshura フォルダを用意するだけの軽い奥義。

$ErrorActionPreference = "Stop"

$GhRepo     = if ($env:MECHAASHURA_REPO)   { $env:MECHAASHURA_REPO }   else { "Getabako/MechaAshura" }
$Branch     = if ($env:MECHAASHURA_BRANCH) { $env:MECHAASHURA_BRANCH } else { "main" }
$InstallDir = if ($env:MECHAASHURA_HOME)   { $env:MECHAASHURA_HOME }   else { Join-Path ([Environment]::GetFolderPath("Desktop")) "MechaAshura" }

function Write-Cyan($m)  { Write-Host $m -ForegroundColor Cyan }
function Write-Green($m) { Write-Host $m -ForegroundColor Green }
function Write-Red($m)   { Write-Host $m -ForegroundColor Red }

try {
  Write-Cyan "▶ メカアシュラ君を呼び出します"

  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Red "✗ git が見つかりません。先に『第一の儀（環境構築）』を実行してください:"
    Write-Red "  iwr -useb https://service.if-juku.net/Ashura/setup.ps1 | iex"
    exit 1
  }

  if (Test-Path (Join-Path $InstallDir ".git")) {
    $dirty = git -C $InstallDir status --porcelain 2>$null
    if ($dirty) {
      Write-Cyan "▶ あなたの変更（放り込んだZIPなど）を保持したまま更新をスキップします"
    } else {
      Write-Cyan "▶ 既存のメカアシュラ君を最新版に更新します"
      git -C $InstallDir fetch --quiet origin $Branch
      git -C $InstallDir reset --quiet --hard "origin/$Branch"
    }
  } else {
    Write-Cyan "▶ ダウンロードします → $InstallDir"
    if (Test-Path $InstallDir) { Remove-Item -Recurse -Force $InstallDir }
    git clone --quiet --depth 1 --branch $Branch "https://github.com/$GhRepo.git" $InstallDir
  }

  Invoke-Item $InstallDir

  Write-Green ""
  Write-Green "✓ 準備完了！ デスクトップの MechaAshura フォルダができました。"
  Write-Green ""
  Write-Green "  次にやること:"
  Write-Green "  1. 改造したい奥義のZIPを、この MechaAshura フォルダに放り込む"
  Write-Green "  2. Claude Code（または Codex）のアプリで、このフォルダを開く"
  Write-Green "  3. チャットで『起動して』と話しかける"
  Write-Green ""
  Write-Green "  あとはメカアシュラ君が「何を改造したいんじゃ？」と聞いてくれます。"
}
catch {
  Write-Red ""
  Write-Red "──────────────────────────────────────────"
  Write-Red "  途中で止まりました。上の赤い文字（エラー）をそのままコピーして、"
  Write-Red "  Codex か Claude Code に貼り付け『このエラーを直して』と頼んでください。"
  Write-Red "──────────────────────────────────────────"
  throw
}
