---
name: onboard
description: 新しく来た人向けのプロジェクト入門ガイドを作る
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
---
# 入門ガイド生成

このプロジェクトに初めて来た人向けの解説を作る。中高生にもわかる日本語で書く。

## 手順

### ステップ1: プロジェクトの自動分析

以下を自動で検出する:

1. **技術スタック**: package.json, requirements.txt, go.mod 等から判定
2. **エントリポイント**: `src/index.ts`, `app/page.tsx`, `main.py` 等を特定
3. **ディレクトリ構成**: 主要ディレクトリの役割を推測
4. **環境変数**: `.env.example` から必要なキーを把握
5. **起動コマンド**: package.json の scripts 等から検出
6. **テストコマンド**: test スクリプトを検出

### ステップ2: コードの読み順を決定

エントリポイントから依存を辿って「読むべき順番」を決める:

```
1. 設定ファイル     → package.json, tsconfig.json, .env.example
2. エントリポイント  → src/index.ts or app/layout.tsx
3. ルーティング     → app/api/**, pages/**
4. コアロジック     → src/lib/**, src/services/**
5. データモデル     → prisma/schema.prisma, src/models/**
6. ユーティリティ   → src/utils/**
7. テスト          → __tests__/**, *.test.ts
```

### ステップ3: 入門ガイドの生成

以下のフォーマットで `docs/onboarding.md` を生成する:

```markdown
# プロジェクト入門ガイド

## このプロジェクトは何？
[1〜2文で目的を説明]

## 技術スタック
| カテゴリ | 技術 | バージョン | 役割 |
|---------|------|-----------|------|
| フロント | Next.js | 14.x | UIの描画 |
| DB | PostgreSQL | 16 | データの保存 |

## セットアップ（コピペで動く）
```bash
npm install
cp .env.example .env.local
npx prisma migrate dev
npm run dev
```

## ディレクトリ構成
```
src/
├── app/          ← ページ（URLに対応）
├── components/   ← UI部品
├── lib/          ← ビジネスロジック
└── utils/        ← 便利関数
```

## コードの読み方（この順番で読む）
1. **まず**: `[ファイル]` — [なぜ最初に読むか]
2. **次に**: `[ファイル]` — [理由]

## よく使うコマンド
| コマンド | やること |
|---------|---------|
| `npm run dev` | 開発サーバーを起動 |
| `npm test` | テストを実行 |

## 開発ルール
- [コミット規約]
- [テスト方針]
```

### ステップ4: セットアップの検証

可能であれば `npm install` 等を実行してセットアップ手順が動くか確認する。

## エッジケース

| 状況 | 対処 |
|------|------|
| README.md がない | 入門ガイドと同時にREADME作成を提案 |
| パッケージマネージャ不明 | ユーザーに聞く |
| モノレポ | 各パッケージの役割を説明 |
| 環境変数不明 | .env.example がなければユーザーに聞く |
