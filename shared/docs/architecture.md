<!-- このファイルはテンプレートです。/init-project スキルが自動で埋めます。手動で {{...}} を埋めないでください。 -->
# {{PROJECT_NAME}} アーキテクチャ設計書

## 概要
{{PROJECT_DESCRIPTION}}

## 技術スタック
| カテゴリ | 技術 | バージョン |
|---------|------|-----------|
| フロントエンド | {{FE_TECH}} | {{VERSION}} |
| バックエンド | {{BE_TECH}} | {{VERSION}} |
| データベース | {{DB_TECH}} | {{VERSION}} |
| ホスティング | {{HOST}} | - |

## ディレクトリ構成
```
{{PROJECT_NAME}}/
├── src/
│   ├── app/          # ページ・ルーティング
│   ├── components/   # UIコンポーネント
│   ├── lib/          # ユーティリティ・設定
│   ├── types/        # 型定義
│   └── hooks/        # カスタムフック
├── tests/            # テストファイル
├── public/           # 静的アセット
└── docs/             # ドキュメント
```

## データモデル
```
{{ENTITY_1}}
├── id: UUID (PK)
├── {{FIELD}}: {{TYPE}}
└── created_at: timestamp

{{ENTITY_2}}
├── id: UUID (PK)
├── {{FIELD}}: {{TYPE}}
└── {{ENTITY_1}}_id: UUID (FK)
```

## 画面構成
1. **{{SCREEN_1}}**: {{DESCRIPTION}}
2. **{{SCREEN_2}}**: {{DESCRIPTION}}
3. **{{SCREEN_3}}**: {{DESCRIPTION}}

## API設計
| メソッド | パス | 説明 |
|---------|------|------|
| GET | /api/{{resource}} | 一覧取得 |
| POST | /api/{{resource}} | 新規作成 |
| GET | /api/{{resource}}/[id] | 詳細取得 |
| PUT | /api/{{resource}}/[id] | 更新 |
| DELETE | /api/{{resource}}/[id] | 削除 |

## セキュリティ方針
- 認証: {{AUTH_METHOD}}
- 環境変数: `.env.local` で管理（git管理外）
