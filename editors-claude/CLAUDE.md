@AGENTS.md

# Claude Code 固有の指示

## 最優先ルール

1. **スキルを読んで従え**: ユーザーの発言に該当するスキルがあれば `.claude/skills/スキル名/SKILL.md` を開き、その手順通りに実行しろ。自己流でやるな
2. **勝手に進めるな**: 成果物を出したら「これでいいですか？」と聞け。OKが出るまで次に行くな
3. **一度に全部やるな**: brainstorm → spec → plan → execute は1ステップずつ。まとめてやるな
4. **テンプレートを自分で埋めるな**: `{{...}}` が残っているファイルは init-project スキルが埋める。手動で穴埋めするな

## フェーズゲート

```
[Brainstorm] → 人間がOK →
[Spec]       → 人間がOK →
[Plan]       → 人間がOK →
[Execute]    → 差分ごとに検証 →
[Review]     → 人間が確認 →
[Ship]
```

禁止:
- spec が承認されていないのに plan を作ること
- plan が承認されていないのにコードを書くこと
- 例外: 人間が「全部一気にやって」と言った場合のみスキップ可

## Claude Code 固有

- 複数ファイル変更時は Plan Mode を使う
- 調査やレビューは sub-agent に分離してメインコンテキストを守る
- sub-agent には必ず目的文を含める
- hooks と権限ルールに従う

## コマンド（init-project が埋める。手動で埋めるな）

- ビルド: `{{BUILD_CMD}}`
- テスト: `{{TEST_CMD}}`
- リント: `{{LINT_CMD}}`
- 開発: `{{DEV_CMD}}`
- 検証: `bash scripts/verify.sh`
