#!/usr/bin/env bash
# Vibe Coding Starter Kit - セットアップスクリプト
#
# 対話モード:  bash setup.sh my-app
# 指定モード:  bash setup.sh my-app claude-code cursor
# ヘルプ:      bash setup.sh --help

set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── エディタ名 → フォルダ名の変換 ─────────────────
resolve_folder() {
  case "$1" in
    claude-code)  echo "editors-claude"   ;;
    cursor)       echo "editors-cursor"   ;;
    windsurf)     echo "editors-windsurf" ;;
    antigravity)  echo "editors-gemini"   ;;
    gemini-cli)   echo "editors-gemini"   ;;
    codex)        echo "editors-codex"    ;;
    *)            echo ""                 ;;
  esac
}

# ─── ヘルプ ─────────────────────────────────────────
show_help() {
  cat <<'HELP'
Vibe Coding Starter Kit

使い方:
  bash setup.sh <プロジェクト名>                    ← 対話で選ぶ
  bash setup.sh <プロジェクト名> <エディタ名...>    ← 直接指定

エディタ名:
  claude-code   … Claude Code (ターミナルCLI)
  cursor        … Cursor (VS Code系AI IDE)
  windsurf      … Windsurf (VS Code系AI IDE)
  antigravity   … Antigravity (GoogleのAI IDE)
  gemini-cli    … Gemini CLI (ターミナルCLI)
  codex         … Codex (OpenAIのCLI)

例:
  cd Desktop/starter-kit
  bash setup.sh my-app                        ← 対話モード
  bash setup.sh my-app claude-code            ← Claude Code だけ
  bash setup.sh my-app claude-code cursor     ← 複数併用

※ どのエディタでも好きなAIモデルが使えます。
  エディタ = 開発ツール、モデル = AIの頭脳。別物です。
HELP
  exit 0
}

# ─── エディタ名のバリデーション ─────────────────────
validate_editor() {
  local input="$1"

  # 正しいエディタ名ならそのまま返す
  local folder
  folder=$(resolve_folder "$input")
  if [ -n "$folder" ]; then
    echo "$input"
    return 0
  fi

  # よくある間違いを救済
  case "$input" in
    claude)
      echo "" >&2
      echo "⚠  'claude' ではなく 'claude-code' を使ってください。" >&2
      echo "   (claude = AIモデル名、claude-code = エディタ名)" >&2
      echo "" >&2
      echo "claude-code"
      return 0
      ;;
    gemini)
      echo "" >&2
      echo "⚠  'gemini' だけだとモデル名と紛らわしいです。" >&2
      echo "   どちらですか？" >&2
      echo "   1) Gemini CLI (ターミナル)" >&2
      echo "   2) Antigravity (Google AI IDE)" >&2
      echo "" >&2
      printf "番号を入力 (1/2): " >&2
      read -r choice
      if [ "$choice" = "2" ]; then
        echo "antigravity"
      else
        echo "gemini-cli"
      fi
      return 0
      ;;
    *)
      echo "エラー: '$input' は不明なエディタ名です" >&2
      echo "" >&2
      echo "使えるエディタ:" >&2
      echo "  claude-code / cursor / windsurf / antigravity / gemini-cli / codex" >&2
      return 1
      ;;
  esac
}

# ─── 対話モード ─────────────────────────────────────
interactive_select() {
  echo ""
  echo "┌─────────────────────────────────────────┐"
  echo "│  どのエディタで開発しますか？            │"
  echo "│  （複数選べます。番号をスペース区切り）  │"
  echo "└─────────────────────────────────────────┘"
  echo ""
  echo "  1) Claude Code      … ターミナルで動くCLI"
  echo "  2) Cursor           … VS Code系のAI IDE"
  echo "  3) Windsurf         … VS Code系のAI IDE"
  echo "  4) Antigravity      … GoogleのAI IDE"
  echo "  5) Gemini CLI       … ターミナルで動くCLI"
  echo "  6) Codex            … OpenAIのCLI"
  echo ""
  echo "※ AIモデル(Claude, Gemini等)はどのエディタでも選べます。"
  echo "  ここでは「どのエディタで書くか」だけ選んでください。"
  echo ""
  printf "番号を入力 (例: 1 or 1 2): "
  read -r selections

  SELECTED_EDITORS=()
  for sel in $selections; do
    case "$sel" in
      1) SELECTED_EDITORS+=("claude-code")  ;;
      2) SELECTED_EDITORS+=("cursor")       ;;
      3) SELECTED_EDITORS+=("windsurf")     ;;
      4) SELECTED_EDITORS+=("antigravity")  ;;
      5) SELECTED_EDITORS+=("gemini-cli")   ;;
      6) SELECTED_EDITORS+=("codex")        ;;
      *)
        echo "エラー: '$sel' は無効な番号です (1〜6)"
        exit 1
        ;;
    esac
  done

  if [ ${#SELECTED_EDITORS[@]} -eq 0 ]; then
    echo "エラー: 1つ以上選んでください"
    exit 1
  fi

  # 確認
  echo ""
  echo "選択したエディタ:"
  for ed in "${SELECTED_EDITORS[@]}"; do
    echo "  ✓ $ed"
  done
  printf "これでOK？ (Y/n): "
  read -r ok
  if [ "$ok" = "n" ] || [ "$ok" = "N" ]; then
    echo "中断しました。もう一度実行してください。"
    exit 0
  fi
}

# ─── メイン処理 ─────────────────────────────────────

# ヘルプ
case "${1:-}" in
  --help|-h) show_help ;;
esac

# 引数チェック
if [ $# -lt 1 ]; then
  echo "使い方: bash setup.sh <プロジェクト名> [エディタ名...]"
  echo "詳しく: bash setup.sh --help"
  exit 1
fi

PROJECT="$1"; shift

# エディタ選択: 引数があれば指定モード、なければ対話モード
if [ $# -gt 0 ]; then
  SELECTED_EDITORS=()
  for arg in "$@"; do
    resolved=$(validate_editor "$arg") || exit 1
    SELECTED_EDITORS+=("$resolved")
  done
else
  interactive_select
fi

# 既存ディレクトリの上書き警告
if [ -d "$PROJECT" ] && [ "$(ls -A "$PROJECT" 2>/dev/null)" ]; then
  echo ""
  echo "警告: '$PROJECT' は既に存在し、ファイルが含まれています。"
  echo "キットの設定ファイルが追加されます（既存コードは消えません）。"
  printf "続行しますか？ (y/N): "
  read -r confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "中断しました。"
    exit 0
  fi
fi

# プロジェクトディレクトリ作成
mkdir -p "$PROJECT"

# 共通ファイルをコピー
rsync -a "$KIT_DIR/shared/" "$PROJECT/"
echo "  + shared (共通ファイル)"

# 各エディタの設定をコピー
for editor in "${SELECTED_EDITORS[@]}"; do
  folder=$(resolve_folder "$editor")
  rsync -a "$KIT_DIR/$folder/" "$PROJECT/"
  echo "  + $editor"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  セットアップ完了: $PROJECT"
echo "  エディタ: $(IFS=', '; echo "${SELECTED_EDITORS[*]}")"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "次のステップ:"
echo "  cd $PROJECT"
echo "  エディタを起動して「このプロジェクトを初期化して」と指示"
echo ""
