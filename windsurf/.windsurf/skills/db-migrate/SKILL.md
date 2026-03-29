---
name: db-migrate
description: データベースの構造変更ファイルを作る
user-invocable: true
disable-model-invocation: true
---
# DBマイグレーション生成

データベースの構造変更を管理するマイグレーションファイルを作る。

## 手順

### ステップ1: ORM/マイグレーションツールの検出
以下の順に確認して、使用ツールを特定する:

| 確認するファイル | ツール |
|-----------------|--------|
| `prisma/schema.prisma` | Prisma |
| `drizzle.config.ts` または `drizzle.config.js` | Drizzle |
| `manage.py` + `settings.py` 内の `DATABASES` | Django |
| `alembic.ini` または `alembic/` ディレクトリ | Alembic (SQLAlchemy) |
| `knexfile.js` または `knexfile.ts` | Knex.js |
| `ormconfig.ts` または `data-source.ts` (TypeORM) | TypeORM |
| `sequelize` in package.json | Sequelize |
| `migrations/` + `go.mod` 内の `golang-migrate` | golang-migrate |

- 何も見つからない場合: 「マイグレーションツールが検出できません。どのツールを使いますか?」と聞く
- 複数見つかった場合: 「複数のツールが見つかりました」と一覧を見せて選んでもらう

### ステップ2: 変更内容をユーザーに確認する
- どんな変更をしたいか聞く。よくある変更の種類:
  - テーブル追加 (新しいデータの種類を保存する)
  - カラム追加 (既存テーブルに項目を追加する)
  - カラム変更 (型の変更、NOT NULL制約の追加等)
  - インデックス追加 (検索を速くする)
  - リレーション追加 (テーブル間の関連)
  - テーブル削除 / カラム削除

### ステップ3: スキーマ変更 vs データ移行の区別
- **スキーマ変更**: テーブルやカラムの構造を変える(追加、削除、型変更)
- **データ移行**: 既存データの変換や移動(例: カラム分割、値の変換)
- データ移行が必要な場合:
  1. まずスキーマ変更(新カラム追加)をマイグレーションで実行
  2. 次にデータ移行スクリプトを別ファイルで作成
  3. 最後に不要になった旧カラムを削除するマイグレーションを作成
  - この3ステップを1つのマイグレーションにまとめない(失敗時の切り分けが困難になる)

### ステップ4: ツール別のマイグレーション作成

#### Prisma
1. `prisma/schema.prisma` を編集してモデルを変更する
2. `npx prisma migrate dev --name <変更の名前>` でマイグレーションファイルを自動生成
3. 生成されたSQLファイル (`prisma/migrations/日時_名前/migration.sql`) を確認する
4. `npx prisma generate` でクライアントを再生成する
- ロールバック: Prismaには組み込みのロールバック機能がない。手動で逆のマイグレーションを作るか、`npx prisma migrate reset` で全リセット(開発環境のみ)

#### Drizzle
1. `src/db/schema.ts` (スキーマファイル) を編集する
2. `npx drizzle-kit generate` でマイグレーションSQLを生成する
3. `npx drizzle-kit migrate` でマイグレーションを実行する
4. 生成されたファイルは `drizzle/` ディレクトリに保存される
- ロールバック: `npx drizzle-kit drop` で最後のマイグレーションを削除(未適用の場合)

#### Django
1. `models.py` を編集してモデルを変更する
2. `python manage.py makemigrations` でマイグレーションファイルを自動生成
3. `python manage.py migrate` で適用する
4. 生成されたファイルは `アプリ名/migrations/` に保存される
- ロールバック: `python manage.py migrate アプリ名 前のマイグレーション番号` で戻せる

#### Alembic (SQLAlchemy)
1. モデルファイルを編集する
2. `alembic revision --autogenerate -m "変更の説明"` でマイグレーションを自動生成
3. 生成されたファイルの `upgrade()` と `downgrade()` を確認する
4. `alembic upgrade head` で適用する
- ロールバック: `alembic downgrade -1` で1つ戻る

#### Knex.js
1. `npx knex migrate:make 変更の名前` でファイルを作成する
2. `exports.up` と `exports.down` を実装する
3. `npx knex migrate:latest` で適用する
- ロールバック: `npx knex migrate:rollback` で最後のバッチを戻す

### ステップ5: マイグレーション前のチェック
- 破壊的な変更がないか確認する:
  - カラム削除 → 本当にどこからも参照されていないか
  - 型変更 → 既存データが新しい型に変換できるか
  - NOT NULL追加 → 既存のNULL値をどうするか(デフォルト値が必要)
- 既存データが多いテーブルへの変更はロック時間に注意(本番環境)

### ステップ6: ロールバック戦略
- 全てのマイグレーションにはロールバック(逆操作)を定義する
- ロールバックできない変更(データ削除等)の場合はその旨をコメントに書く
- ロールバック手順をユーザーに伝える:
  ```
  ロールバック手順:
  1. [ツール別のロールバックコマンド]
  2. アプリケーションを前のバージョンに戻す
  3. 動作確認する
  ```

### ステップ7: 本番環境でのマイグレーション注意事項
- 必ず開発環境で先にテストする
- 本番実行前にDBのバックアップを取る
- ダウンタイムが発生する変更(テーブルロック等)はメンテナンス時間に行う
- 大きなテーブルへのALTER TABLE は `pt-online-schema-change` (MySQL) や `pg_repack` (PostgreSQL) の使用を検討する
- マイグレーションが途中で失敗した場合の復旧手順を事前に決めておく

### 出力フォーマット
マイグレーション作成後、以下を表示する:
```
## マイグレーション作成完了

ファイル: [生成されたファイルのパス]
内容: [変更の概要]

適用コマンド: [コマンド]
ロールバック: [コマンド]
確認コマンド: [テーブル構造確認コマンド]
```
