---
name: backup
description: GitHubにバックアップする
user-invocable: true
disable-model-invocation: true
---
# GitHubバックアップ

現在の変更をコミットしてGitHubにプッシュする。

## 手順

### ステップ1: 変更の確認
1. `git status` で変更を確認する
2. 変更がなければ「バックアップする変更がありません」と伝えて終了する
3. .env, credentials.json 等の秘密情報がステージされていないか確認する

### ステップ2: コミット
1. `git add` で変更をステージする（ファイル名を明示。`git add .` は使わない）
2. 変更内容から日本語コミットメッセージを自動生成する
3. ユーザーにメッセージを確認してから `git commit` する

### ステップ3: リモートの確認と設定
1. `git remote -v` でリモートが設定済みか確認する
2. リモートがない場合:
   - `gh` コマンドが使えるか確認する
   - 使えれば `gh repo create --private` でリポジトリを作成する
   - 使えなければ「`gh auth login` を実行してください」と案内する

### ステップ4: プッシュ
1. `git push origin` を実行する
2. ブランチが未追跡なら `git push -u origin` にする

### ステップ5: 完了報告

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  バックアップ完了
  コミット: abc1234
  リモート: https://github.com/user/repo
  ブランチ: main
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 失敗時の対処

| 失敗 | 原因 | 対処 |
|------|------|------|
| push 拒否 (認証エラー) | トークン切れ | 「`gh auth login` を実行してください」と案内 |
| push 拒否 (non-fast-forward) | リモートが先に進んでいる | `git pull --rebase origin main` を提案。コンフリクトがあれば解決を手伝う |
| push 拒否 (ファイルサイズ) | 100MB超のファイル | .gitignore に追加するか git-lfs を提案 |
| gh コマンドがない | 未インストール | `brew install gh` を案内 |
| gh 認証切れ | 未ログイン | `gh auth login` を案内 |
