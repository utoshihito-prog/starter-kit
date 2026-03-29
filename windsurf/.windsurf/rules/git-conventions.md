---
trigger: model_decision
description: Git規約 - コミットメッセージの形式
---
# Git規約

- コミットメッセージは日本語
- 形式: `<種別>: <内容>` (例: `feat: ユーザー認証機能を追加`)
- 種別: feat / fix / refactor / test / docs / chore
- 1タスク = 1コミット が基本
- コミット前にテストとリントを実行
- .env, node_modules は絶対にコミットしない
