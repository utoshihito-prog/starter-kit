#!/bin/bash
# Vibe Coding Starter Kit - セットアップスクリプト
# 使い方: bash ~/Desktop/starter-kit/setup.sh <プロジェクト名> <エージェント名...>
# 例:     bash ~/Desktop/starter-kit/setup.sh my-app claude
# 例:     bash ~/Desktop/starter-kit/setup.sh my-app claude cursor

set -e

if [ $# -lt 2 ]; then
  echo "使い方: bash setup.sh <プロジェクト名> <エージェント名...>"
  echo "エージェント: claude / codex / gemini / cursor / windsurf"
  echo ""
  echo "例: bash setup.sh my-app claude"
  echo "例: bash setup.sh my-app claude cursor"
  exit 1
fi

PROJECT="$1"; shift
AGENTS=("$@")
TOSHI_DIR="$(cd "$(dirname "$0")" && pwd)"

# 既存ディレクトリの上書き警告
if [ -d "$PROJECT" ] && [ "$(ls -A "$PROJECT" 2>/dev/null)" ]; then
  echo "警告: '$PROJECT' は既に存在し、ファイルが含まれています。"
  echo "上書きすると既存ファイルが変更される可能性があります。"
  read -r -p "続行しますか？ (y/N): " confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "中断しました。"
    exit 0
  fi
fi

# エージェント名の検証
for agent in "${AGENTS[@]}"; do
  if [ ! -d "$TOSHI_DIR/$agent" ]; then
    echo "エラー: '$agent' は存在しないエージェントです"
    echo "使えるエージェント: claude / codex / gemini / cursor / windsurf"
    exit 1
  fi
done

# プロジェクトディレクトリ作成
mkdir -p "$PROJECT"

# 共通ファイルをコピー (隠しファイル含む)
rsync -a "$TOSHI_DIR/shared/" "$PROJECT/"

# 各エージェントのファイルをコピー (隠しフォルダ含む)
for agent in "${AGENTS[@]}"; do
  rsync -a "$TOSHI_DIR/$agent/" "$PROJECT/"
  echo "  + $agent"
done

echo ""
echo "セットアップ完了: $PROJECT"
echo "エージェント: $(IFS=', '; echo "${AGENTS[*]}")"
echo ""
echo "次のステップ:"
echo "  cd $PROJECT"
echo "  <エージェントを起動>"
echo "  /init-project"
