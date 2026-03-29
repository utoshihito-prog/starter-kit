#!/bin/bash
# プロジェクト検証スクリプト
# /init-project が自動でコマンドを設定する
set -e

echo "=== 検証開始 ==="

run_if_set() {
  local label="$1"
  local cmd="$2"
  if [ -n "$cmd" ] && [[ "$cmd" != *"{{"* ]]; then
    echo "--- $label ---"
    eval "$cmd"
  else
    echo "--- $label: スキップ（未設定） ---"
  fi
}

run_if_set "リント" "{{LINT_CMD}}"
run_if_set "型チェック" "{{TYPECHECK_CMD}}"
run_if_set "テスト" "{{TEST_CMD}}"
run_if_set "ビルド" "{{BUILD_CMD}}"

echo "=== 全チェック通過 ==="
