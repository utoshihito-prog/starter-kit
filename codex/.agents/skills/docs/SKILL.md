---
name: docs
description: ドキュメントを自動で作る
argument-hint: "[スコープ]"
user-invocable: true
disable-model-invocation: true
---
# ドキュメント生成
コードからドキュメントを自動生成する。
$ARGUMENTS でスコープを指定:
- ファイルパス → そのファイルのJSDoc/docstring
- "api" → API仕様書
- "readme" → README.md
- "project" → プロジェクト全体の概要
手順:
1. 対象コードを読む
2. 既存ドキュメントのスタイルに合わせる
3. 中高生にも分かる日本語で書く
4. 使用例も含める
