---
name: changelog
description: 「何が変わったか」のリストをgitの記録から自動で作る
user-invocable: true
disable-model-invocation: true
---
# 更新履歴生成
gitのコミット履歴から、ユーザー向けの更新履歴を生成する。
手順:
1. `git log --oneline` から前回リリース以降のコミットを取得
2. コミットを分類: 新機能 / バグ修正 / 改善 / その他
3. 技術的すぎる表現をユーザー向けに書き直す
4. CHANGELOG.md に追記 (日付 + バージョン)
