---
name: perf
description: 遅い部分を見つけて速くする方法を出す
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
---
# パフォーマンス分析

コードの遅い部分を見つけて、速くする方法を提案する。

## 手順

### ステップ1: プロジェクトの種類を判定
- フロントエンド（React/Vue/Next.js等）→ レンダリング・バンドルサイズ中心
- バックエンド（Express/FastAPI等）→ クエリ・アルゴリズム中心
- フルスタック → 両方チェック

### ステップ2: 以下のパターンを検索

| カテゴリ | チェック | 検索方法 |
|---------|---------|---------|
| アルゴリズム | O(n²)以上のネストループ | forの中のfor、filter+find の組み合わせ |
| DB | N+1クエリ | ループ内のDB呼び出し、include/joinの欠落 |
| DB | インデックス不足 | WHERE句で使うカラムにインデックスがあるか |
| React | 不要な再レンダリング | useMemo/useCallback の欠落、context の過剰利用 |
| React | 巨大コンポーネント | 1コンポーネントが200行超 |
| バンドル | 巨大importr | `import _ from 'lodash'` 等のフルインポート |
| メモリ | リソースリーク | close/cleanup が呼ばれていないストリーム・接続 |
| キャッシュ | 再計算の無駄 | 同じ結果を何度も計算している箇所 |

### ステップ3: 結果を出力

```
## パフォーマンス分析結果

| # | ファイル | 行 | 種類 | 影響度 | 問題 | 修正案 | 期待改善 |
|---|---------|-----|------|--------|------|--------|---------|
| 1 | src/api/search.ts | 45 | N+1クエリ | HIGH | ループ内でDBクエリ | joinを使って1クエリに | レスポンス 500ms→50ms |
| 2 | src/components/List.tsx | 12 | 再レンダリング | MEDIUM | 毎回全リスト再描画 | React.memoで囲む | 描画時間 50%削減 |
| 3 | src/utils/calc.ts | 78 | アルゴリズム | HIGH | O(n²)のフィルタ | Mapで O(n)に | 大量データで100倍速 |

### 修正案の詳細

#### #1: N+1クエリの修正
Before:
```ts
for (const user of users) {
  const posts = await db.posts.findMany({ where: { userId: user.id } })
}
```
After:
```ts
const posts = await db.posts.findMany({ where: { userId: { in: userIds } } })
```

### サマリー
- HIGH: X件 / MEDIUM: X件 / LOW: X件
- 最も効果が大きい修正: #X
```

## エッジケース

| 状況 | 対処 |
|------|------|
| 明確なボトルネックがない | 「重大な問題は見つかりませんでした」と報告。プロファイリングツールの利用を提案 |
| パフォーマンス計測ができない | Before/Afterの計測方法を提案（console.time、lighthouse等） |
| 最適化が早すぎる | 「まだユーザー数が少ないため、最適化は後回しでも問題ありません」と判断を示す |
