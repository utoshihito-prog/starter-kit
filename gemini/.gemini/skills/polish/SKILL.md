---
name: polish
description: さっき書いたコードをもう一回見直してシンプルにする
user-invocable: true
disable-model-invocation: true
context: fork
---
# コード磨き上げ

最近変更したコードを別の視点で見直して、シンプルにできるところを見つける。

手順:
1. `git diff HEAD~1` で最近の変更を取得
2. 以下の観点でチェック:
   - もっとシンプルに書ける箇所
   - 重複しているコード
   - 不要な抽象化
   - 変数名・関数名の改善
   - コメントで補足が必要な箇所
3. Before/After で改善案を提示
4. ユーザーが承認したら修正を適用
5. テストが通ることを確認
