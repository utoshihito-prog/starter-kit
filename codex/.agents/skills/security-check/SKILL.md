---
name: security-check
description: セキュリティの穴がないか調べる
user-invocable: true
disable-model-invocation: true
context: fork
---
# セキュリティチェック

OWASP Top 10をベースにコードの脆弱性をスキャンする。

## 手順

### ステップ1: プロジェクトの言語・フレームワークを特定する
- ファイル拡張子やpackage.json、requirements.txt等から判定する
- フレームワーク固有のチェック項目を追加する(後述)

### ステップ2: 以下のパターンを検索する

#### SQLインジェクション (CRITICAL)
- 検索パターン: テンプレートリテラルや文字列結合でSQLを組み立てている箇所
  - `query(\`SELECT.*\$\{` (テンプレートリテラルでSQL)
  - `"SELECT.*" \+` (文字列結合でSQL)
  - `f"SELECT.*{` (Python f-string でSQL)
- 安全な例: `db.query('SELECT * FROM users WHERE id = $1', [userId])` ← パラメータ化されている

#### XSS (CRITICAL)
- 検索パターン:
  - `dangerouslySetInnerHTML` (React) → 本当に必要か、入力はサニタイズされているか確認
  - `innerHTML\s*=` (DOM直接操作)
  - `v-html` (Vue) → ユーザー入力を渡していないか確認
  - `\| safe` (Jinja2/Django) → エスケープ無効化
- 安全な方法: テキストコンテンツとして挿入する、DOMPurifyでサニタイズする

#### コマンドインジェクション (CRITICAL)
- 検索パターン:
  - `exec\(.*\$\{` または `exec\(.*\+`
  - `child_process` の `exec` にユーザー入力を渡していないか
  - `subprocess.call.*shell=True` (Python)
- 安全な方法: `execFile` を使う、入力をバリデーションする

#### ハードコードされた秘密情報 (HIGH)
- 検索パターン:
  - `(password|secret|token|api_key|apikey)\s*[:=]\s*["'][^"']+["']`
  - `AKIA[0-9A-Z]{16}` (AWSアクセスキー)
  - `sk-[a-zA-Z0-9]{20,}` (OpenAI)
  - `ghp_[a-zA-Z0-9]{36}` (GitHub Personal Access Token)
  - `xoxb-` (Slack Bot Token)

#### 認証・認可の不備 (HIGH)
- APIルートに認証ミドルウェアが付いているか確認する
- 管理者専用エンドポイントに権限チェックがあるか確認する
- JWTの検証がある場合、署名検証を省略していないか確認する(`algorithms`パラメータの指定)

#### 入力バリデーション (MEDIUM)
- APIのリクエストボディにバリデーションがあるか(zod, joi, class-validator等)
- ファイルアップロードにサイズ・形式チェックがあるか
- URLパラメータの型チェック(数値のはずがstringのまま使われていないか)

#### 安全でないデシリアライゼーション (HIGH)
- `JSON.parse` にtry-catchがあるか
- `eval()` を使っていないか → 絶対に使わない
- `new Function()` を使っていないか
- `pickle.loads` (Python) にユーザー入力を渡していないか

#### エラーメッセージの情報漏洩 (MEDIUM)
- 本番環境でスタックトレースを返していないか
- エラーメッセージにDB名、テーブル名、内部パスを含めていないか
- `NODE_ENV === 'production'` でエラー詳細を隠しているか

#### 依存パッケージの脆弱性 (MEDIUM)
- `npm audit` または `pip audit` の実行を提案する
- `package-lock.json` が最新か確認する

#### CORS設定 (MEDIUM)
- `Access-Control-Allow-Origin: *` になっていないか
- credentialsモードでワイルドカードOriginを許可していないか

#### HTTPセキュリティヘッダー (LOW)
- Content-Security-Policy、X-Frame-Options、X-Content-Type-Options が設定されているか
- HTTPS強制 (Strict-Transport-Security) が設定されているか

### ステップ3: フレームワーク固有のチェック
- **React/Next.js**: `dangerouslySetInnerHTML`, API Routeの認証漏れ, `getServerSideProps`内でのユーザー入力処理
- **Express**: `helmet` ミドルウェアの使用, rate limiting, CORS設定
- **Django**: `ALLOWED_HOSTS` の設定, `DEBUG = True` が本番で無効か, CSRF保護
- **FastAPI**: 依存性注入での認証チェック, CORSミドルウェアの設定

### ステップ4: 結果を重要度マトリックスで出力

```
## セキュリティチェック結果

### 重要度サマリー
| 重要度 | 件数 |
|--------|------|
| CRITICAL | 1 |
| HIGH | 2 |
| MEDIUM | 3 |
| LOW | 1 |

### 詳細

| # | ファイル | 行 | 重要度 | カテゴリ | 問題 | 修正方法 |
|---|---------|-----|--------|---------|------|----------|
| 1 | src/api/user.ts | 42 | CRITICAL | SQLインジェクション | テンプレートリテラルでSQLを組み立てている | パラメータ化クエリに変更する |
```

### ステップ5: 各発見への対処
- CRITICAL: 即座に修正コードを提示する。ユーザーが望めばその場で修正する
- HIGH: 修正方法を具体的に示す。リリース前に修正が必要と伝える
- MEDIUM: 改善提案として記録する。次のスプリントで対応を推奨
- LOW: 参考情報として共有する

### チェックで何も見つからなかった場合
- 「主要な脆弱性は検出されませんでした」と報告する
- ただし「自動チェックには限界があるので、重要なリリース前には専門家のレビューも検討してください」と付け加える
