---
name: backup
description: GitHubにバックアップする
user-invocable: true
disable-model-invocation: true
---
# GitHubバックアップ

現在の変更をコミットしてGitHubにプッシュする。

手順:
1. `git status` で変更を確認
2. 変更があれば `git add` して自動でコミットメッセージを生成
3. コミットメッセージをユーザーに確認
4. `git commit`
5. リモートが未設定なら `gh repo create --private` で作成
6. `git push origin`
7. 完了を報告
