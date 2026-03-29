---
name: save-skill
description: 便利だったやり方をスキルとして保存する
user-invocable: true
disable-model-invocation: true
---
# スキル保存

便利なワークフローをスキルとして保存する。

手順:
1. ユーザーに聞く:
   - スキル名 (英語、ハイフン区切り)
   - 何をするスキルか (日本語で説明)
   - このプロジェクトだけで使う or 全プロジェクトで使う

2. SKILL.md を生成:
   - name, description (日本語) を frontmatter に設定
   - ワークフローの手順をマークダウンで記述
   - 必要に応じて disable-model-invocation, context: fork 等を設定

3. 保存先:
   - プロジェクト用 → `.claude/skills/{name}/SKILL.md`
   - グローバル用 → `~/.claude/skills/{name}/SKILL.md`
   (Cursor の場合は .cursor/skills/, Gemini は .gemini/skills/ 等、検出したエージェントに合わせる)

4. 保存完了を報告
