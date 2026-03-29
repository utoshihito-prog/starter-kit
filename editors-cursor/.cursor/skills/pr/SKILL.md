---
name: pr
description: プルリクエストを作る
argument-hint: "[ターゲットブランチ]"
user-invocable: true
disable-model-invocation: true
---
# PR作成

ブランチの全コミットからPRタイトル・説明を作って、GitHub PRを作成する。

## 手順

### ステップ1: 状態の確認
1. 現在のブランチが main/master でないことを確認する
   - main にいる場合: 「main ブランチです。PRを作るには別ブランチに切り替えてください」と案内
2. `git log main..HEAD --oneline` で全コミットを取得する
   - コミットがない場合: 「main との差分がありません」と伝えて終了
3. 未コミットの変更がある場合: 「未コミットの変更があります。先にコミットしますか？」と聞く

### ステップ2: PR内容の生成
1. `git diff main...HEAD` で全変更を把握する
2. ターゲットブランチ: $ARGUMENTS があればそれを使う。なければ `main`
3. PRタイトル（70字以内）と説明を生成する:

```markdown
## Summary
- [変更内容を箇条書き]

## Test plan
- [ ] [テスト方法のチェックリスト]
```

### ステップ3: ユーザーに確認
1. PRタイトルと説明を見せる
2. 「この内容でPRを作りますか？」と確認する

### ステップ4: PR作成
1. リモートにブランチをプッシュする: `git push -u origin HEAD`
2. `gh pr create --title "..." --body "..."` でPRを作成する
3. PR URLを表示する

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PR作成完了
  URL: https://github.com/user/repo/pull/42
  タイトル: feat: ユーザー認証機能を追加
  ターゲット: main ← feature/auth
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 失敗時の対処

| 状況 | 対処 |
|------|------|
| main ブランチにいる | 新しいブランチ作成を提案 |
| コミットがない | 「差分がありません」で終了 |
| gh CLI がない | `brew install gh` を案内。手動URL生成も提示 |
| PR が既に存在する | 「既にPRがあります: [URL]」と既存PRのリンクを表示 |
| push が失敗 | /backup と同じ失敗対処を実行 |
