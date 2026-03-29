---
name: save-skill
description: 便利だったやり方をスキルとして保存する
user-invocable: true
disable-model-invocation: true
---
# スキル保存

便利なワークフローをスキルとして保存する。

## 手順

### ステップ1: ユーザーに聞く
- スキル名 (英語、ハイフン区切り。例: `deploy-staging`)
- 何をするスキルか (日本語で説明)
- このプロジェクトだけで使う or 全プロジェクトで使う

### ステップ2: 使用中のエディタを検出する

| 検出するファイル/フォルダ | エディタ | スキル保存先 |
|------------------------|---------|------------|
| `.claude/` | Claude Code | `.claude/skills/{name}/SKILL.md` |
| `.cursor/` | Cursor | `.cursor/skills/{name}/SKILL.md` |
| `.windsurf/` | Windsurf | `.windsurf/skills/{name}/SKILL.md` |
| `.gemini/` | Gemini CLI / Antigravity | `.gemini/skills/{name}/SKILL.md` |
| `.agents/` | Codex | `.agents/skills/{name}/SKILL.md` |

グローバル保存の場合はホームディレクトリ配下（例: `~/.claude/skills/{name}/SKILL.md`）

### ステップ3: SKILL.md を生成する

```yaml
---
name: {name}
description: {日本語の説明}
user-invocable: true
disable-model-invocation: true
---
```

- ワークフローの手順をマークダウンで記述する
- 手順は具体的にステップバイステップで書く
- 出力フォーマットがあれば定義する
- 必要に応じて `context: fork`、`argument-hint` 等を追加する

### ステップ4: 保存と検証
1. ファイルを保存する
2. 「/[スキル名] でスキルを呼び出せます」と案内する

## エッジケース

| 状況 | 対処 |
|------|------|
| 同名のスキルが存在する | 「既に存在します。上書きしますか？」と確認 |
| エディタが検出できない | 「どのエディタを使っていますか？」と聞く |
| スキル名が不正 | 英語ハイフン区切りに自動変換して確認 |
