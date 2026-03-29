---
name: plan
description: 機能をタスクに分けて計画する
argument-hint: "[機能名]"
user-invocable: true
disable-model-invocation: true
context: fork
agent: Plan
---
# 機能設計・タスク分解

機能をタスクに分けて計画を作る。コードは書かない。

手順:
1. $ARGUMENTS の機能要求を理解する
2. 既存のコードベースを調査して、関連ファイルとパターンを把握
3. タスクを分解:
   - 各タスクは15分以内で完了できる粒度
   - テスト可能で、明確な完了条件がある
   - 1つの関心事に集中
4. 以下を出力:
   - タスクの一覧 (順序付き)
   - 各タスクで変更するファイル
   - 依存関係
   - 受入条件
5. plans/ に日付プレフィックス付きで保存（例: plans/2026-03-29-feature-name.md）
6. ユーザーに確認してから docs/tasks.md に追記
