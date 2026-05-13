# プロジェクト設定

## 最優先ルール（絶対に守ること）

1. **スキルを読んで従え**: ユーザーの発言に該当するスキルがあれば `.agents/skills/スキル名/SKILL.md` を開き、その手順通りに実行しろ。自己流でやるな
2. **勝手に進めるな**: 成果物を出したら「これでいいですか？」と聞け。OKが出るまで次に行くな
3. **一度に全部やるな**: spec → plan → execute は1ステップずつ。まとめてやるな
4. **テンプレートを自分で埋めるな**: `{{...}}` が残っているファイルは `/auto` または初回起動時にユーザーと一緒に埋める。勝手に推測しない

## ユーザーの発言 → やること対応表

ユーザーがこう言ったら、対応するスキルファイルを読んでその通りに動け。

| ユーザーの発言 | 読むスキル |
|--------------|-----------|
| 「とりあえず進めて」「お任せ」 | `.agents/skills/auto/SKILL.md` |
| 「仕様書を作って」 | `.agents/skills/spec/SKILL.md` |
| 「計画して」「タスクに分けて」 | `.agents/skills/plan/SKILL.md` |
| 「TDDで」「テスト先に」 | `.agents/skills/tdd/SKILL.md` |
| 「整理して」「リファクタ」 | `.agents/skills/refactor/SKILL.md` |
| 「バグ調べて」 | `.agents/skills/diagnose/SKILL.md` |
| 「テスト作って」 | `.agents/skills/test-gen/SKILL.md` |
| 「レビューして」 | `.agents/skills/review/SKILL.md` |
| 「セキュリティ見て」 | `.agents/skills/security-check/SKILL.md` |
| 「シンプルにして」 | `.agents/skills/polish/SKILL.md` |
| 「コミットして」 | `.agents/skills/commit/SKILL.md` |
| 「PR作って」 | `.agents/skills/pr/SKILL.md` |
| 「テスト通してpush」「リリース」 | `.agents/skills/land/SKILL.md` |
| 「引き継ぎ作って」 | `.agents/skills/handoff/SKILL.md` |
| 「再開」 | `.agents/skills/resume/SKILL.md` |
| 「/スキル名」 | `.agents/skills/スキル名/SKILL.md` |

## 初回（プロジェクトに初めて触る時）

1. このファイルを最後まで読む
2. ユーザーに「何をしますか？」と聞く
3. ユーザーの回答に対応するスキルを上の表から探して実行する

**禁止: docs/ のテンプレートを見て勝手に穴埋めを始めること。ユーザーの指示を待て。**

## フェーズゲート（飛ばすな）

```
[Spec]       → 人間が承認 →
[Plan]       → 人間が承認 →
[Execute]    → 差分ごとに検証 →
[Review]     → 人間が確認 →
[Ship]
```

禁止:
- spec が承認されていないのに plan を作ること
- plan が承認されていないのにコードを書くこと
- 人間が「進めて」と言っていないのに次に行くこと
- 例外: 人間が「全部一気にやって」と言った場合のみスキップ可

## コマンド（/auto または初回セットアップで埋める。手動で穴埋めしない）

- ビルド: `{{BUILD_CMD}}`
- テスト: `{{TEST_CMD}}`
- リント: `{{LINT_CMD}}`
- 開発: `{{DEV_CMD}}`

## ルール

- まず計画を立てる。複数ファイルを変える作業は必ず plan を作ってから
- 最小の正しい差分を出す。動いてるコードを理由なく書き直さない
- 成功を宣言する前に検証する。scripts/verify.sh があればそれを使う
- 既存のパッケージマネージャとタスクランナーに従う
- 必要なければ依存パッケージを追加しない
- 迷ったら docs/ を読んでからコードを触る

## コンテキスト管理

- コンテキスト使用率は40%以下を維持する
- 40%を超えたらタスクをまとめて新セッションを開始する
- 1タスク = 1セッションが基本

## 言葉遣い

- 中学生・高校生にも分かる日本語で
- 冗長な長文は禁止。簡潔に

## Git

- コミットメッセージは日本語。形式: <種別>: <内容>
- 種別: feat / fix / refactor / test / docs / chore
- 1タスク = 1コミット
- コミット前に検証を実行

## 安全境界（人間の確認なしに変更しない）

- 認証・認可・課金・権限
- DB schema / migration
- CI/CD パイプライン
- 本番環境の設定・シークレット

## 参照

- プロダクト: docs/product.md
- 設計: docs/architecture.md
- ワークフロー: docs/dev-workflow.md
- テスト: docs/testing.md
- タスク: docs/tasks.md
- 全スキル: `.agents/skills/` の各フォルダ

## 注意: サンドボックス

Codex はデフォルトでサンドボックス内で動作する。
/pr 等のネットワークが必要なスキルは
`danger-full-access` モードで実行する必要がある。
