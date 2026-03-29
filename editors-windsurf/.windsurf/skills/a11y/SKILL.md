---
name: a11y
description: 目が見えにくい人でも使えるかチェックする
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
---
# アクセシビリティチェック

WCAG 2.1 をベースに、誰でも使えるUIになっているかチェックする。

## 手順

### ステップ1: UIファイルの検出

以下のファイルを検索する:
- React: `*.tsx`, `*.jsx` で JSX を含むファイル
- Vue: `*.vue` ファイル
- HTML: `*.html` ファイル
- テンプレート: `*.ejs`, `*.hbs` 等

### ステップ2: 以下のルールでチェック

| # | チェック | WCAG基準 | 重要度 | Good | Bad |
|---|---------|---------|--------|------|-----|
| 1 | 画像にalt属性 | 1.1.1 | CRITICAL | `<img alt="ロゴ">` | `<img>` (altなし) |
| 2 | フォームにラベル | 1.3.1 | CRITICAL | `<label for="email">` | `<input>` (ラベルなし) |
| 3 | 色のコントラスト | 1.4.3 | HIGH | コントラスト比4.5:1以上 | 薄いグレーの文字 |
| 4 | キーボード操作 | 2.1.1 | HIGH | `onClick + onKeyDown` | `onClick` のみの div |
| 5 | フォーカス順序 | 2.4.3 | MEDIUM | 自然なtab順序 | tabindex乱用 |
| 6 | ARIA属性の正しさ | 4.1.2 | MEDIUM | `role="button" aria-label="閉じる"` | `role="button"` (ラベルなし) |
| 7 | 見出しの階層 | 1.3.1 | LOW | h1→h2→h3 の順 | h1→h3 (h2飛ばし) |
| 8 | リンクテキスト | 2.4.4 | LOW | `詳細を見る` | `こちら` |

### ステップ3: 自動チェックツールの提案

プロジェクトに以下のツールがインストールされているか確認する:
- `@axe-core/react` → React向け自動チェック
- `eslint-plugin-jsx-a11y` → Lint時にチェック

入っていなければインストールを提案する。

### ステップ4: 結果を出力

```
## アクセシビリティチェック結果

| # | ファイル | 行 | WCAG基準 | 重要度 | 問題 | 修正方法 |
|---|---------|-----|---------|--------|------|---------|
| 1 | src/components/Card.tsx | 15 | 1.1.1 | CRITICAL | img にalt属性がない | alt="商品画像" を追加 |
| 2 | src/app/login/page.tsx | 32 | 1.3.1 | CRITICAL | input にラベルがない | label要素を追加 |
| 3 | src/components/Button.tsx | 8 | 2.1.1 | HIGH | divにonClickのみ | button要素に変更 |

### サマリー
- CRITICAL: X件（ユーザーがサイトを使えない可能性）
- HIGH: X件（操作が困難）
- MEDIUM: X件（改善推奨）
- LOW: X件（あると良い）
```

## エッジケース

| 状況 | 対処 |
|------|------|
| UIファイルがない（APIのみ） | 「UIコンポーネントが見つかりません」で終了 |
| コンポーネントライブラリ使用 | ライブラリ自体のa11y対応状況も確認 |
| SSR/SSG | サーバーサイドレンダリング時のHTML出力も確認 |
