---
name: sync-agents
description: ルールを全エージェントに反映する
user-invocable: true
disable-model-invocation: true
---
# マルチエージェント同期

docs/rules/ のルール原本を、プロジェクト内の各エージェント設定に反映する。

## 手順

### ステップ1: エージェント設定の検出

プロジェクト内を走査して、どのエージェント設定があるか検出する:

| 検出対象 | エージェント |
|---------|------------|
| `.claude/` | Claude Code |
| `.cursor/` | Cursor |
| `.windsurf/` | Windsurf |
| `AGENTS.md` | Codex |
| `GEMINI.md` | Gemini CLI / Antigravity |

**1つしか検出できない場合**: 「エージェントが1つしかありません。同期の必要はありません」と伝えて終了する。

### ステップ2: ルール原本の読み込み

`docs/rules/*.md` のルール原本を全て読み込む。

### ステップ3: 各エージェント形式に変換

#### Claude Code → `.claude/rules/*.md`
```yaml
---
description: ルールの説明
globs: "**/*"
---
[ルール内容]
```

#### Cursor → `.cursor/rules/*.mdc`
```
---
description: ルールの説明
globs: "**/*"
alwaysApply: true
---
[ルール内容]
```

#### Windsurf → `.windsurf/rules/*.md`
```
---
trigger: always
description: ルールの説明
globs: "**/*"
---
[ルール内容]
```

#### Codex → `AGENTS.md` に参照として記載
```markdown
## ルール
以下のルールに従ってください:
@docs/rules/code-style.md
@docs/rules/security.md
```

#### Gemini → `GEMINI.md` に参照として記載
（Codexと同じ形式）

### ステップ4: 差分の報告

```
## 同期結果

| ファイル | 状態 |
|---------|------|
| .claude/rules/code-style.md | 更新 |
| .cursor/rules/code-style.mdc | 更新 |
| .windsurf/rules/code-style.md | 変更なし |
| AGENTS.md | 更新 |

更新: 3ファイル / 変更なし: 1ファイル
```

## エッジケース

| 状況 | 対処 |
|------|------|
| docs/rules/ がない | 「ルール原本がありません。先にルールを作成してください」と案内 |
| エージェントが1つだけ | 同期不要と伝えて終了 |
| 変換先にカスタム内容がある | 「エージェント固有の設定があります。上書きしますか？」と確認 |
