---
name: test-gen
description: テストを自動で作る
argument-hint: "[ファイルパス]"
user-invocable: true
disable-model-invocation: true
---
# テスト自動生成

指定されたファイルに対してテストを自動生成する。

手順:
1. プロジェクトのテストフレームワークを検出 (jest, vitest, pytest 等)
2. 既存テストのパターンを分析 (配置、命名、スタイル)
3. 対象ファイル $ARGUMENTS を読む
4. 以下をカバーするテストを生成:
   - 正常系 (ハッピーパス)
   - 異常系 (エラーケース)
   - 境界値
   - エッジケース
5. 既存テストと同じスタイル・規約で書く
6. テストを実行して通ることを確認
