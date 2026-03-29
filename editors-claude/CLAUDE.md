@AGENTS.md

# Claude Code 固有の指示

- 複数ファイル変更時は Plan Mode を使う
- 調査やレビューは sub-agent に分離してメインコンテキストを守る
- sub-agent には必ず目的文を含める（NG:「認証を調べて」 OK:「レート制限改善のために認証を調べて」）
- hooks と権限ルールに従う

## コマンド
- ビルド: `{{BUILD_CMD}}`
- テスト: `{{TEST_CMD}}`
- リント: `{{LINT_CMD}}`
- 開発: `{{DEV_CMD}}`
- 検証: `bash scripts/verify.sh`
