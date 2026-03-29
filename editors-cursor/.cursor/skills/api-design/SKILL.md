---
name: api-design
description: APIの設計ルール(URL命名・エラー形式等)をチェックする
argument-hint: "[スコープ]"
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
---
# API設計チェック

REST/GraphQL APIの設計ルールが統一されているかチェックする。

## 手順

### ステップ1: APIルートファイルの検出
1. フレームワークを判定する:
   - Next.js App Router: `app/api/**/route.ts`
   - Next.js Pages: `pages/api/**/*.ts`
   - Express: `router.get/post/put/delete` を含むファイル
   - FastAPI: `@app.get/post/put/delete` を含むファイル
2. 全エンドポイントを一覧にする

### ステップ2: 以下のルールでチェック

| カテゴリ | ルール | Good | Bad |
|---------|--------|------|-----|
| URL命名 | リソースは複数形 | `/api/users` | `/api/user` |
| URL命名 | ケバブケース | `/api/user-profiles` | `/api/userProfiles` |
| URL命名 | ネスト3段以内 | `/api/users/123/posts` | `/api/users/123/posts/456/comments/789` |
| HTTPメソッド | 取得=GET, 作成=POST | `GET /api/users` | `POST /api/getUsers` |
| レスポンス | 一貫したJSON構造 | `{ data, meta }` | ファイルごとに形式バラバラ |
| エラー | 統一されたエラー形式 | `{ error, message }` | 文字列だけ返す |
| ステータスコード | 適切なコード | 201 Created | 200 for create |
| ページネーション | 一貫した方式 | 全APIがcursor方式 | cursorとoffsetが混在 |
| 認証 | 必要なルートに認証あり | middleware付き | 認証チェック漏れ |

### ステップ3: 結果を出力

```
## API設計チェック結果

### エンドポイント一覧
| メソッド | パス | 認証 | 概要 |
|---------|------|------|------|
| GET | /api/users | 要 | ユーザー一覧 |
| POST | /api/users | 不要 | ユーザー作成 |

### 問題点

| # | エンドポイント | カテゴリ | 重要度 | 問題 | 修正案 |
|---|-------------|---------|--------|------|--------|
| 1 | GET /api/user | URL命名 | LOW | 単数形 | `/api/users` に変更 |
| 2 | POST /api/users | ステータスコード | MEDIUM | 200を返している | 201 Created に変更 |
| 3 | DELETE /api/users/:id | 認証 | CRITICAL | 認証チェックなし | 認証middleware追加 |

### サマリー
- CRITICAL: X件 / HIGH: X件 / MEDIUM: X件 / LOW: X件
- 全体評価: [1文で]
```

## エッジケース

| 状況 | 対処 |
|------|------|
| APIが存在しない | 「APIエンドポイントが見つかりません」と報告 |
| GraphQL | REST固有のルール（URL命名等）はスキップし、スキーマの一貫性をチェック |
| 外部API連携のみ | 「自前のAPIはありません。外部API呼び出しの一貫性をチェックしますか？」と聞く |
