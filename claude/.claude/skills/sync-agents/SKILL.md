---
name: sync-agents
description: ルールを全エージェントに反映する
user-invocable: true
disable-model-invocation: true
---
# マルチエージェント同期

docs/rules/ のルール原本を、プロジェクト内の各エージェント設定に反映する。

手順:
1. プロジェクト内を走査して、どのエージェント設定があるか検出:
   - `.claude/` → Claude Code
   - `.cursor/` → Cursor
   - `.windsurf/` → Windsurf
   - `AGENTS.md` → Codex
   - `GEMINI.md` → Gemini

2. `docs/rules/*.md` のルール原本を全て読み込む

3. 検出した各エージェント形式に変換して書き出す:
   - Claude → `.claude/rules/*.md` に globs 付き YAML frontmatter で生成
   - Cursor → `.cursor/rules/*.mdc` に globs + alwaysApply 付きで生成
   - Windsurf → `.windsurf/rules/*.md` に trigger + globs 付きで生成
   - Codex → `AGENTS.md` の参照パスを更新
   - Gemini → `GEMINI.md` の参照パスを更新

4. 差分があったファイルを報告
