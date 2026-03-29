---
name: api-design
description: APIの設計ルール(URL命名・エラー形式等)をチェックする
user-invocable: true
disable-model-invocation: true
context: fork
---
# API設計チェック
REST/GraphQL APIの設計ルールが統一されているかチェックする。
チェック項目:
- URL命名: 複数形、ケバブケース、ネストの深さ
- HTTPメソッド: GET/POST/PUT/DELETEの使い分け
- レスポンス形式: 一貫したJSON構造
- エラーレスポンス: ステータスコードとエラーメッセージの統一
- ページネーション: cursor or offset、一貫性
- バージョニング: URL or ヘッダー
出力: 問題点リスト + 改善案
