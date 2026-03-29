---
name: seed
description: 本物っぽいテスト用ダミーデータを作る
user-invocable: true
disable-model-invocation: true
---
# ダミーデータ生成

開発・テスト用の本物っぽいデータを作る。

## 手順

### ステップ1: データモデルの把握

以下の順でスキーマを探す:

1. `prisma/schema.prisma` → Prisma モデル
2. `src/db/schema.ts` → Drizzle スキーマ
3. `**/models.py` → Django モデル
4. `docs/architecture.md` → 設計書のデータモデル
5. 見つからない場合: ユーザーにテーブル構成を聞く

### ステップ2: データ生成ルール

| データ型 | 生成ルール | 例 |
|---------|-----------|-----|
| 名前（日本語） | 現実的な日本人名 | 田中太郎、佐藤花子 |
| メール | example.com ドメイン | taro.tanaka@example.com |
| 電話番号 | 090/080 + 8桁 | 090-1234-5678 |
| 日付 | 直近1年以内のランダム | 2025-08-15 |
| 住所（日本語） | 都道府県 + 市区町村 | 東京都渋谷区神宮前1-2-3 |
| ID | UUID v4 | a1b2c3d4-... |
| 金額 | 商品なら100〜100,000円 | 2,980 |
| パスワード | ハッシュ済みの固定値 | bcrypt("password123") |
| enum | 定義されたの値からランダム | "active", "inactive" |

### ステップ3: リレーションの整合性

外部キーの整合性を保つ:

1. **親テーブルを先に作る**: users → posts → comments の順
2. **外部キー参照**: posts.user_id は必ず存在する users.id を参照する
3. **1対多**: 1ユーザーに3〜5件の投稿を紐づける
4. **多対多**: 中間テーブルのレコードも生成する
5. **UNIQUE制約**: 重複しない値を生成する

### ステップ4: 出力形式

ORM に合わせた形式で出力する:

| ORM | 出力形式 | 出力先 |
|-----|---------|--------|
| Prisma | `prisma/seed.ts` (TypeScript) | `npx prisma db seed` で実行 |
| Drizzle | `src/db/seed.ts` | `npx tsx src/db/seed.ts` |
| Django | `fixtures/*.json` | `python manage.py loaddata` |
| SQLAlchemy | `scripts/seed.py` | `python scripts/seed.py` |
| なし | `seed-data.json` (汎用JSON) | 手動でインポート |

### ステップ5: データ量の確認

デフォルト:
| エンティティ | 件数 |
|------------|------|
| メインエンティティ（users等） | 20件 |
| 子エンティティ（posts等） | 親1件あたり3〜5件 |
| マスタデータ（categories等） | 全種類 |

ユーザーに「この量でいいですか？」と確認する。

### ステップ6: 実行と確認

1. シードスクリプトを実行する
2. データが正しく入ったか確認する
3. package.json の scripts に seed コマンドを追加することを提案する

## エッジケース

| 状況 | 対処 |
|------|------|
| スキーマが見つからない | ユーザーにテーブル構成を聞く |
| 循環参照 | 片方をnullable にしてNULLで作成 → 後から更新 |
| UNIQUE制約 | カウンターやUUIDで一意性を保証 |
| 既存データがある | 「既存データを消してから入れますか？追加しますか？」と確認 |
