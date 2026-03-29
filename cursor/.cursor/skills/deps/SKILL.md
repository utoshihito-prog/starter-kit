---
name: deps
description: 使ってるパッケージの問題をチェックする
user-invocable: true
disable-model-invocation: true
---
# 依存パッケージ監査
プロジェクトの依存パッケージの問題をチェックする。
手順:
1. パッケージマネージャーを検出 (npm, pnpm, pip, cargo等)
2. チェック:
   - 既知の脆弱性 (npm audit等)
   - メジャーバージョンが古いパッケージ
   - 使われていないパッケージ (import検索)
   - ライセンス問題
3. 優先度付きで対処リストを出力
4. アップグレードコマンドを提案
