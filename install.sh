#!/usr/bin/env bash
# メカアシュラ君 — one-line installer
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Getabako/MechaAshura/main/install.sh)"
#
# 何度貼ってもOK。デスクトップに MechaAshura フォルダを用意するだけの軽い奥義。

set -e

GH_REPO="${MECHAASHURA_REPO:-Getabako/MechaAshura}"
BRANCH="${MECHAASHURA_BRANCH:-main}"
INSTALL_DIR="${MECHAASHURA_HOME:-$HOME/Desktop/MechaAshura}"

cyan()  { printf "\033[36m%s\033[0m\n" "$*"; }
green() { printf "\033[32m%s\033[0m\n" "$*"; }
red()   { printf "\033[31m%s\033[0m\n" "$*" >&2; }

__ash_on_error() {
  red ""
  red "──────────────────────────────────────────"
  red "  途中で止まりました。上の赤い文字（エラー）をそのままコピーして、"
  red "  Codex か Claude Code に貼り付け『このエラーを直して』と頼んでください。"
  red "──────────────────────────────────────────"
}
trap __ash_on_error ERR

cyan "▶ メカアシュラ君を呼び出します"

if [[ "$(uname)" != "Darwin" ]]; then
  red "✗ install.sh は macOS 向けです。"
  red "Windows の方は PowerShell で:"
  red "  iwr -useb https://raw.githubusercontent.com/$GH_REPO/main/install.ps1 | iex"
  exit 1
fi

command -v git >/dev/null 2>&1 || {
  red "✗ git が見つかりません。先に『第一の儀（環境構築）』を実行してください:"
  red "  /bin/bash -c \"\$(curl -fsSL https://service.if-juku.net/Ashura/setup.sh)\""
  exit 1
}

if [[ -d "$INSTALL_DIR/.git" ]]; then
  if [[ -n "$(git -C "$INSTALL_DIR" status --porcelain 2>/dev/null)" ]]; then
    cyan "▶ あなたの変更（放り込んだZIPなど）を保持したまま更新をスキップします"
  else
    cyan "▶ 既存のメカアシュラ君を最新版に更新します"
    git -C "$INSTALL_DIR" fetch --quiet origin "$BRANCH"
    git -C "$INSTALL_DIR" reset --quiet --hard "origin/$BRANCH"
  fi
else
  cyan "▶ ダウンロードします → $INSTALL_DIR"
  rm -rf "$INSTALL_DIR"
  git clone --quiet --depth 1 --branch "$BRANCH" \
    "https://github.com/$GH_REPO.git" "$INSTALL_DIR"
fi

open "$INSTALL_DIR" 2>/dev/null || true

green ""
green "✓ 準備完了！ デスクトップの MechaAshura フォルダができました。"
green ""
green "  次にやること:"
green "  1. 改造したい奥義のZIPを、この MechaAshura フォルダに放り込む"
green "  2. Claude Code（または Codex）のアプリで、このフォルダを開く"
green "  3. チャットで『起動して』と話しかける"
green ""
green "  あとはメカアシュラ君が「何を改造したいんじゃ？」と聞いてくれます。"
trap - ERR
