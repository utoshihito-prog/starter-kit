---
name: pr
description: プルリクエストを作る
user-invocable: true
disable-model-invocation: true
---
# PR作成

ブランチの全コミットからPRタイトル・説明を作って、GitHub PRを作成する。

手順:
1. `git log main..HEAD --oneline` で全コミットを取得
2. `git diff main...HEAD` で全変更を把握
3. PRタイトル (70字以内) と説明を生成:
   - Summary: 変更内容を箇条書き
   - Test plan: テスト方法
4. ユーザーに確認
5. `gh pr create --title "..." --body "..."`
6. PR URLを表示
