---
name: secret-scan
description: コードやgit履歴からAPIキー漏れを検出する
user-invocable: true
disable-model-invocation: true
---
# 秘密情報スキャン

コードとgit履歴からAPIキー・パスワード・トークンの漏洩を検出する。

## 手順

### ステップ1: ソースコード内のスキャン
以下のパターンをプロジェクト内の全ファイルで検索する(node_modules, .git, dist等は除く):

#### AWSキー
- `AKIA[0-9A-Z]{16}` (AWSアクセスキーID)
- `aws_secret_access_key\s*[:=]\s*["']` (AWSシークレット)

#### APIキー・トークン
- `sk-[a-zA-Z0-9]{20,}` (OpenAI APIキー)
- `ghp_[a-zA-Z0-9]{36}` (GitHub Personal Access Token)
- `gho_[a-zA-Z0-9]{36}` (GitHub OAuth Token)
- `github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}` (GitHub Fine-grained Token)
- `xoxb-[0-9]+-[a-zA-Z0-9]+` (Slack Bot Token)
- `xoxp-[0-9]+-[a-zA-Z0-9]+` (Slack User Token)
- `SG\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+` (SendGrid APIキー)
- `sk_live_[a-zA-Z0-9]+` (Stripe秘密キー)
- `rk_live_[a-zA-Z0-9]+` (Stripe制限キー)

#### パスワード・接続文字列
- `(password|passwd|pwd)\s*[:=]\s*["'][^"']+["']` (ハードコードされたパスワード)
- `(mongodb|postgres|mysql|redis):\/\/[^"'\s]+:[^"'\s]+@` (認証情報付きの接続文字列)
- `DATABASE_URL\s*[:=]\s*["'][^"']+["']`

#### 秘密鍵
- `-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----` (秘密鍵ファイル)
- `-----BEGIN PGP PRIVATE KEY BLOCK-----`

#### 汎用パターン
- `(secret|token|api_key|apikey|auth_token|access_token)\s*[:=]\s*["'][a-zA-Z0-9+/=_-]{8,}["']`

### ステップ2: .gitignore の確認
- `.gitignore` ファイルが存在するか確認する
- 以下のパターンが含まれているか確認する:
  - `.env` または `.env*` (環境変数ファイル)
  - `.env.local`
  - `.env.production`
  - `*.pem` (秘密鍵)
  - `credentials.json`
  - `serviceAccountKey.json`
- 不足しているパターンがあれば追加を提案する

### ステップ3: .envファイルの状態確認
- `.env`, `.env.local`, `.env.production` 等が存在するか確認する
- `git ls-files` でこれらがgit管理下にないか確認する
- git管理下にある場合: 「.envファイルがgitに追加されています。直ちに削除が必要です」と警告する
- `.env.example` が存在するか確認する。なければ作成を提案する(値は空にする)

### ステップ4: git履歴のスキャン
- `git log -p --all -S 'AKIA'` でAWSキーが過去のコミットに含まれていないか確認する
- `git log -p --all -S 'sk-'` でOpenAIキーを確認する
- `git log -p --all -S 'password'` でパスワードを確認する
- `git log -p --all -S 'BEGIN PRIVATE KEY'` で秘密鍵を確認する
- 注意: リポジトリが大きい場合は時間がかかる。ユーザーに「履歴スキャンには時間がかかります」と先に伝える
- より高速なツールとして `gitleaks` の利用を提案する:
  - インストール: `brew install gitleaks`
  - 実行: `gitleaks detect --source . --verbose`

### ステップ5: 結果の出力

```
## 秘密情報スキャン結果

| # | 場所 | 種類 | 内容(マスク済み) | 対処 |
|---|------|------|-----------------|------|
| 1 | src/config.ts:15 | OpenAI APIキー | sk-****...abcd | 環境変数に移動 |
| 2 | git履歴 (abc1234) | AWSアクセスキー | AKIA****...WXYZ | キーをローテーション |
| 3 | .env (git管理下) | 環境変数ファイル | - | gitから削除 |
```

### ステップ6: 発見時の対処手順

#### ソースコード内で見つかった場合
1. 値を環境変数に移動する (`.env.local` に記載)
2. コード側は `process.env.変数名` で参照するように書き換える
3. `.env.example` に変数名だけ追加する(値は空)
4. 変更をコミットする

#### git履歴で見つかった場合(重要)
1. まず該当する秘密情報をすぐにローテーション(無効化して再発行)する
   - AWSキー: AWSコンソールでキーを無効化→新しいキーを発行
   - GitHubトークン: Settings → Developer settings → 該当トークンを削除→再発行
   - 各サービスのダッシュボードで対応する
2. git履歴からの削除は `git filter-branch` や `BFG Repo-Cleaner` で可能だが、強制プッシュが必要
   - `bfg --replace-text passwords.txt` (BFG Repo-Cleaner)
   - この操作はチーム全員に影響するため、必ずユーザーに確認してから実行する
3. ローテーションが最優先。履歴削除は二の次

#### .envがgit管理下にある場合
1. `git rm --cached .env` でgitの追跡を外す(ファイル自体は消えない)
2. `.gitignore` に `.env*` を追加する
3. コミットする
4. もし秘密情報が含まれていたら、上記「git履歴で見つかった場合」も実行する

### 何も見つからなかった場合
- 「秘密情報は検出されませんでした」と報告する
- 「今後の対策として、pre-commitフックで秘密情報チェックを入れることを推奨します」と伝える
- 推奨ツール: `gitleaks` をpre-commitフックに設定する方法を案内する
