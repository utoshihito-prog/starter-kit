---
name: docs
description: ドキュメントを自動で作る
argument-hint: "[スコープ]"
user-invocable: true
disable-model-invocation: true
context: fork
---
# ドキュメント生成

$ARGUMENTS で指定されたスコープに応じて、コードからドキュメントを自動生成する。

## 手順

### ステップ1: スコープの判定

| $ARGUMENTS | スコープ | やること |
|-----------|---------|---------|
| ファイルパス | ファイル | JSDoc / docstring を生成 |
| `api` | API仕様書 | エンドポイント一覧と仕様を生成 |
| `readme` | README | README.md を生成 |
| `project` | プロジェクト概要 | アーキテクチャ図 + 技術スタック一覧 |
| 空 / 未指定 | 自動判定 | 最も必要なものを提案 |

### ステップ2: 既存ドキュメントのスタイル検出

- JSDoc / TSDoc / docstring のスタイルを検出
- 言語: 日本語メインか英語メインか
- 既存スタイルがあればそれに合わせる。なければ日本語で書く

---

## スコープ別の手順

### ファイルスコープ: JSDoc / docstring 生成

1. ファイルを読んで言語を判定する
2. エクスポートされた関数・クラス・型にドキュメントを付ける
3. 既にドキュメントがある箇所は上書きせず、不足分だけ追加する

出力例 (TypeScript):
```typescript
/**
 * ユーザーのメールアドレスでログインを試みる。
 *
 * @param email - メールアドレス
 * @param password - パスワード (平文)
 * @returns セッショントークン
 * @throws {AuthError} 認証失敗時
 *
 * @example
 * const token = await login("user@example.com", "pass123")
 */
```

### API スコープ: API仕様書生成

1. APIルートファイルを検出する
2. 各エンドポイントを一覧にする

出力フォーマット:
```markdown
# API仕様書

## エンドポイント一覧
| メソッド | パス | 認証 | 概要 |
|---------|------|------|------|
| GET | /api/users | 要 | ユーザー一覧 |
| POST | /api/users | 不要 | ユーザー作成 |

## 詳細

### GET /api/users
- リクエスト: `?page=1&limit=20`
- レスポンス: `{ data: User[], total: number }`
```

### README スコープ

以下のセクションで README.md を生成する:
- プロジェクト名と概要
- セットアップ手順
- 使い方
- 技術スタック
- ディレクトリ構成

### Project スコープ

docs/architecture.md を生成/更新する:
- レイヤー構成図（ASCII）
- 技術スタック一覧テーブル
- データフロー図

## エッジケース

| 状況 | 対処 |
|------|------|
| 既存ドキュメントがある | 上書きしてよいか確認 |
| 複数言語が混在 | 言語ごとにスタイルを変える |
| $ARGUMENTS がファイルパスだが存在しない | 「見つかりません」と似た名前を提案 |
