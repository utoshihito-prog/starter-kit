---
name: architecture
description: 設計のお作法(SOLID等)をチェックする
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
---
# 設計チェック

コードベースの設計をSOLID原則・クリーンアーキテクチャの観点でチェックする。

チェック項目:
- 単一責任の原則: 1つのクラス/モジュールが複数の仕事をしていないか
- 開放閉鎖の原則: 拡張しやすく、修正が少なくて済む設計か
- 依存性逆転の原則: 上位モジュールが下位モジュールに直接依存していないか
- 循環依存: モジュール間で循環参照がないか
- レイヤー分離: UI/ロジック/データアクセスが分離されているか
- 責務の肥大化: God Objectがないか

出力:
- 問題点リスト (重要度付き)
- 改善案
- 図 (依存関係のASCII図)
