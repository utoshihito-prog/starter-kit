#!/usr/bin/env bash
# Vibe Coding Starter Kit (Terminal Edition)
#
# 使い方:
#   bash setup.sh <project>                  # 対話で選択
#   bash setup.sh <project> claude-code      # 直接指定 (複数可)
#   bash setup.sh --help

set -euo pipefail

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

resolve_folder() {
  case "$1" in
    claude-code|claude) echo "editors-claude" ;;
    codex)              echo "editors-codex"  ;;
    gemini-cli|gemini)  echo "editors-gemini" ;;
    *)                  echo ""               ;;
  esac
}

show_help() {
  cat <<'HELP'
Vibe Coding Starter Kit — Terminal Edition

対応エディタ (ターミナル3種):
  claude-code   Anthropic Claude Code
  codex         OpenAI Codex CLI
  gemini-cli    Google Gemini CLI

使い方:
  bash setup.sh <project>                          # 対話で選択
  bash setup.sh <project> claude-code              # 1つ指定
  bash setup.sh <project> claude-code codex        # 複数指定

例:
  bash setup.sh my-app claude-code
  bash setup.sh ../existing-project claude-code codex
HELP
  exit 0
}

interactive_select() {
  cat <<'MENU'

エディタを選択 (スペース区切りで複数可):
  1) Claude Code
  2) Codex
  3) Gemini CLI

MENU
  printf "番号 (例: 1 or 1 2): "
  read -r selections
  SELECTED_EDITORS=()
  for sel in $selections; do
    case "$sel" in
      1) SELECTED_EDITORS+=("claude-code") ;;
      2) SELECTED_EDITORS+=("codex")       ;;
      3) SELECTED_EDITORS+=("gemini-cli")  ;;
      *) echo "エラー: '$sel' は無効 (1-3)"; exit 1 ;;
    esac
  done
  [ ${#SELECTED_EDITORS[@]} -eq 0 ] && { echo "1つ以上選択してください"; exit 1; }
}

case "${1:-}" in --help|-h) show_help ;; esac

if [ $# -lt 1 ]; then
  echo "使い方: bash setup.sh <project> [editor...]"
  echo "詳細  : bash setup.sh --help"
  exit 1
fi

PROJECT="$1"; shift

if [ $# -gt 0 ]; then
  SELECTED_EDITORS=()
  for arg in "$@"; do
    folder=$(resolve_folder "$arg")
    if [ -z "$folder" ]; then
      echo "エラー: '$arg' は対応外。claude-code / codex / gemini-cli から選んでください"
      exit 1
    fi
    SELECTED_EDITORS+=("$arg")
  done
else
  interactive_select
fi

if [ -d "$PROJECT" ] && [ "$(ls -A "$PROJECT" 2>/dev/null)" ]; then
  echo "警告: '$PROJECT' は既に存在し中身があります。設定のみ追加します（既存コードは温存）。"
  printf "続行? (y/N): "; read -r ok
  [ "$ok" != "y" ] && [ "$ok" != "Y" ] && { echo "中断"; exit 0; }
fi

mkdir -p "$PROJECT"

rsync -a "$KIT_DIR/shared/" "$PROJECT/"
echo "  + shared"

for editor in "${SELECTED_EDITORS[@]}"; do
  folder=$(resolve_folder "$editor")
  rsync -a "$KIT_DIR/$folder/" "$PROJECT/"
  echo "  + $editor"
done

cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Done: $PROJECT
  Editors: ${SELECTED_EDITORS[*]}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next:
  cd $PROJECT
  $( [[ " ${SELECTED_EDITORS[*]} " == *" claude-code "* ]] && echo "claude" || echo "${SELECTED_EDITORS[0]}" )
  # → 「/auto <やりたいこと>」でスタート
EOF
