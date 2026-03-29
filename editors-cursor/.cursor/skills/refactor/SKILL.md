---
name: refactor
description: コードを整理してきれいにする
argument-hint: "[ファイルパス]"
user-invocable: true
disable-model-invocation: true
---
# リファクタリング

コードの動作を変えずに、構造を整理してきれいにする。

手順:
1. $ARGUMENTS のファイルを読む
2. 以下を分析:
   - DRY違反 (同じことを2回以上書いてる)
   - 長すぎる関数 (30行超)
   - 深いネスト (3段超)
   - 命名の改善余地
   - 責務の分離
3. Before/After で改善案を提示
4. ユーザーが承認したら修正
5. テストが通ることを確認
