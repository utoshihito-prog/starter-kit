# データモデル

## このファイルの位置づけ

受付管理簿、依頼書、月次レポート、お客様情報の構造はこのファイルを正とする。実装時は、代理店ごとに受付システムがExcel、kintone、Microsoft Power Apps等へ差し替わる前提で、ここに定義した論理項目をマッピングする。

出典:
- `_source/shared/reception-ledger.pdf`
- `_source/shared/reception-ledger.xlsx`
- `_source/shared/service-catalog.pdf`
- `_source/shared/service-catalog.xlsx`
- `_source/01-breakdown/request-form.xlsx`
- `_source/01-breakdown/flow-detail.docx`
- `_source/02-lost-device/request-form.xlsx`
- `_source/02-lost-device/flow-detail.docx`
- `_source/03-request-kitting/request-form.xlsx`
- `_source/03-request-kitting/flow-detail.docx`
- `_source/04-monthly-report/flow-detail.pdf`
- `_source/04-monthly-report/flow-detail.docx`

## 受付管理簿スキーマ

| フィールド名 | セル番地 | 型 | 必須/任意 | 説明 | 入力例 |
|---|---|---|---|---|---|
| 項番 | C5 | string | 必須 | 依頼を識別する通し番号 | 001 |
| 受付日 | D5 | date | 必須 | Kが依頼を受け付けた日 | 2022-10-12 |
| キャンセル有無 | E5 | enum | 任意 | 途中キャンセルの管理 | キャンセル |
| 携帯電話番号 | F5 | tel | 必須 | 対象端末の電話番号 | 070-XXXX-XXXX |
| 受付区分 | G5 | enum | 必須 | 依頼種別 | 故障 |
| 発送日 | H5 | date | 任意 | Kが端末を発送した日 | 2022-10-24 |
| 伝票番号 | I5 | string | 任意 | 配送追跡番号 | 47-XXXXXX-XXXX |
| 完了日 | J5 | date | 任意 | 対応完了日 | 2022-10-25 |
| 機種名/対象端末 | K6 | string | 必須 | 現在利用中または対象端末の機種名 | 2021 iPad 64GB |
| 製造番号/対象端末 | L6 | string | 必須 | 対象端末のIMEI等 | 358XXXXXXXXXXXX |
| 申告内容・症状 | M6 | text | 任意 | 故障症状や申告内容。紛失やキッティングでは空欄可 | バッテリーが半日で切れる |
| 機種名/交換品 | N6 | string | 任意 | 交換品の機種名 | 2021 iPad 64GB |
| 製造番号/交換品 | O6 | string | 任意 | 交換品のIMEI等 | 358XXXXXXXXXXXX |
| メモ欄/備考 | P5 | text | 任意 | 旧契約分などの補足 | 旧契約分 |

## 受付管理簿サンプルレコード

実データ由来の電話番号、IMEI、伝票番号はマスキングする。

| 項番 | 受付日 | 携帯電話番号 | 受付区分 | 発送日 | 伝票番号 | 完了日 | 機種名/対象端末 | 製造番号/対象端末 | 申告内容・症状 | 機種名/交換品 | 製造番号/交換品 | メモ欄/備考 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 001 | 2022-10-12 | 070-XXXX-XXXX | 故障 | 2022-10-24 | 47-XXXXXX-XXXX | 2022-10-25 | 2021 iPad 64GB | 358XXXXXXXXXXXX | バッテリーが半日で切れる | 2021 iPad 64GB | 358XXXXXXXXXXXX | 旧契約分 |
| 002 | 2023-02-06 | 070-XXXX-XXXX | 故障 | 2023-02-10 | 47-XXXXXX-XXXX | 2023-02-10 | 2021 iPad 64GB | 355XXXXXXXXXXXX | 不明 | 2021 iPad 64GB | 358XXXXXXXXXXXX | 旧契約分 |
| 003 | 2023-03-06 | 070-XXXX-XXXX | 故障 | 2023-03-07 | 47-XXXXXX-XXXX | 2023-03-07 | 2021 iPad Pro 128GB | 359XXXXXXXXXXXX | 電源が入らない | 2021 iPad Pro 128GB | 359XXXXXXXXXXXX | 旧契約分 |
| 004 | 2023-03-15 | 070-XXXX-XXXX | 故障 | 2023-03-17 | 47-XXXXXX-XXXX | 2023-03-17 | 2021 iPad 64GB | 358XXXXXXXXXXXX | バッテリーの消費が早い | 2021 iPad 64GB | 358XXXXXXXXXXXX | 旧契約分 |
| 005 | 2023-03-30 | 070-XXXX-XXXX | 故障 | 2023-03-31 | 47-XXXXXX-XXXX | 2023-03-31 | 2021 iPad 64GB | 358XXXXXXXXXXXX | バッテリーの消費が早い、一日持たない | 2021 iPad 64GB | 358XXXXXXXXXXXX | 旧契約分 |

## リストマスタ

| マスタ | 値 | 出典 |
|---|---|---|
| 受付区分 | 故障 | `_source/shared/reception-ledger.xlsx` |
| 受付区分 | 紛失・盗難 | `_source/shared/reception-ledger.xlsx` |
| 受付区分 | リクエストキッティング | `_source/shared/reception-ledger.xlsx` |
| 受付区分 | MDM操作代行（プロファイル変更） | `_source/shared/reception-ledger.xlsx` |
| 受付区分 | MDM操作代行（アプリ配信） | `_source/shared/reception-ledger.xlsx` |
| 端末種別 | レンタル | `_source/shared/reception-ledger.xlsx` |
| 端末種別 | 改番・利用者変更 | `_source/shared/reception-ledger.xlsx` |
| 端末種別 | なし | `_source/shared/reception-ledger.xlsx` |
| 対象機種 | 2021 iPad 64GB / iPad（第9世代） | `_source/shared/reception-ledger.xlsx` |
| 対象機種 | 2021 iPad Pro 128GB / iPad Pro（第5世代） | `_source/shared/reception-ledger.xlsx` |
| 対象機種 | 2025 11iPad 128GB / iPad（A16） | `_source/shared/reception-ledger.xlsx` |
| 契約期間 | 2026-03-01から | `_source/shared/reception-ledger.xlsx` |
| 上限件数 | 100 | `_source/shared/reception-ledger.xlsx` |
| 上限カウント条件 | 故障、紛失・盗難、キッティング | `_source/shared/reception-ledger.xlsx` |

## 故障交換機器送付依頼書

| フィールド名 | セル番地 | 型 | 必須/任意 | 説明 | 入力例 |
|---|---|---|---|---|---|
| 申込年 | H5 | number | 必須 | 申込日の年 | 2026 |
| 申込月 | M5 | number | 必須 | 申込日の月 | 4 |
| 申込日 | Q5 | number | 必須 | 申込日の日 | 14 |
| ご契約者名フリガナ | H6 | string | 必須 | 契約企業名のフリガナ | カブシキガイシャサンプル |
| ご契約者名 | F7 | string | 必須 | 契約企業名 | 株式会社サンプル |
| ABM/ASM組織ID | AM7 | string | 条件必須 | ABM/ASM利用時のみ必須 | 123456 |
| 依頼元部署名 | F8 | string | 必須 | 依頼部署 | 情報システム部 |
| 依頼元ご契約代理人様名 | AB8 | string | 必須 | 依頼担当者名 | 山田 太郎 |
| 依頼元電話番号 | F9 | tel | 必須 | 依頼元連絡先 | 03-XXXX-XXXX |
| 依頼元メールアドレス | AB9 | email | 必須 | 依頼元メール | user@example.jp |
| 交換機器送付先郵便番号 | G12 | string | 必須 | K事務所等の郵便番号 | 〒XXX-XXXX |
| 交換機器送付先都道府県 | F14 | string | 必須 | 送付先都道府県 | 大阪府 |
| 交換機器送付先市区町村 | M14 | string | 必須 | 送付先市区町村 | 大阪市 |
| 交換機器送付先町名番地 | T14 | string | 必須 | 送付先住所詳細 | ○○町1-2-3 |
| 交換機器送付先企業名 | F15 | string | 必須 | 送付先企業名 | K（ヘルプデスク） |
| 交換機器送付先部署名 | AB15 | string | 任意 | 送付先部署名 | サポートチーム |
| 交換機器送付先担当者名 | F16 | string | 必須 | 受取担当者 | 佐藤 花子 |
| 交換機器送付先電話番号 | AB16 | tel | 必須 | 送り状用電話番号 | 0X-XXXX-XXXX |
| 対象機器 | F19 | string | 必須 | 故障端末の機種 | iPad 2022 |
| 製造番号 | F20 | string | 必須 | 故障端末のIMEI | 358XXXXXXXXXXXX |
| 色 | AH19 | string | 必須 | 故障端末の色 | スペースグレー |
| 容量 | AH20 | number | 条件必須 | iPhone/iPadのみ | 64 |
| ご利用電話番号 | F21 | tel | 必須 | ハイフンなし | 090XXXXXXXX |
| 承諾事項チェック | F22 | boolean | 条件必須 | 機器情報不明時にチェック | true |
| ポイント利用 | F23 | enum | 任意 | 全ポイント、上限指定、利用しない | 利用しない |
| ポイント上限 | AH23 | number | 条件必須 | 上限指定時のみ | 1000 |
| 故障状態 | J24 | enum | 必須 | 電源断、画面割れ、外損、水濡れ、その他 | 画面割れ |
| 故障内容 | J25 | text | 必須 | 100文字以内 | 落として画面が割れた |
| 決裁番号 | L51 | string | 任意 | D内部の決裁番号 | 関西法営020920号 |
| キッティング情報1 | A57 | text | 任意 | 個別設定情報 | 業務アプリID |
| キッティング情報2 | W57 | text | 任意 | 個別設定情報 | 初期パスワード |
| キッティング情報3 | A58 | text | 任意 | 個別設定情報 | 部署別設定 |
| キッティング情報4 | W58 | text | 任意 | 個別設定情報 | 備考 |

## 紛失時対応依頼書

| フィールド名 | セル番地 | 型 | 必須/任意 | 説明 | 入力例 |
|---|---|---|---|---|---|
| 申込年 | I5 | number | 必須 | 申込日の年 | 2026 |
| 申込月 | N5 | number | 必須 | 申込日の月 | 4 |
| 申込日 | R5 | number | 必須 | 申込日の日 | 14 |
| ご契約者名フリガナ | H6 | string | 必須 | 契約企業名のフリガナ | カブシキガイシャサンプル |
| ご契約者名 | F7 | string | 必須 | 契約企業名 | 株式会社サンプル |
| ABM/ASM組織ID | AM7 | string | 条件必須 | ABM/ASM利用時のみ必須 | 123456 |
| 依頼元部署名 | F8 | string | 必須 | 依頼部署 | 情報システム部 |
| 依頼元ご契約代理人様名 | AB8 | string | 必須 | 依頼担当者名 | 山田 太郎 |
| 依頼元電話番号 | F9 | tel | 必須 | 依頼元連絡先 | 03-XXXX-XXXX |
| 依頼元メールアドレス | AB9 | email | 必須 | 依頼元メール | user@example.jp |
| 交換機器送付先郵便番号 | G12 | string | 必須 | K事務所等の郵便番号 | 〒XXX-XXXX |
| 交換機器送付先都道府県 | F14 | string | 必須 | 送付先都道府県 | 大阪府 |
| 交換機器送付先企業名 | F15 | string | 必須 | 送付先企業名 | K（ヘルプデスク） |
| 交換機器送付先部署名 | AB15 | string | 任意 | 送付先部署名 | サポートチーム |
| 交換機器送付先担当者名 | F16 | string | 必須 | 受取担当者 | 佐藤 花子 |
| 交換機器送付先電話番号 | AB16 | tel | 必須 | 送り状用電話番号 | 0X-XXXX-XXXX |
| 届出年 | F20 | number | 必須 | 遺失届の届出年 | 2026 |
| 届出月 | K20 | number | 必須 | 遺失届の届出月 | 4 |
| 届出日 | O20 | number | 必須 | 遺失届の届出日 | 14 |
| 警察署名 | T20 | string | 条件必須 | オンライン申請時は省略可 | ○○警察署 |
| 遺失届受理番号 | AH20 | string | 必須 | 警察の受理番号 | 遺セ（電子）第XXXX号 |
| 盗難・紛失場所 | F21 | text | 必須 | 発生場所 | 移動中の車内 |
| 盗難・紛失年 | AH21 | number | 必須 | 発生年 | 2026 |
| 盗難・紛失月 | AN21 | number | 必須 | 発生月 | 4 |
| レンタル端末名 | F22 | string | 必須 | 紛失端末の機種名 | iPad 2022 |
| 製造番号 | F23 | string | 必須 | 紛失端末のIMEI | 358XXXXXXXXXXXX |
| 色 | AH22 | string | 必須 | 紛失端末の色 | スペースグレー |
| 容量 | AI23 | number | 条件必須 | iPhone/iPadのみ | 64 |
| ご利用電話番号 | F24 | tel | 必須 | ハイフンなし | 090XXXXXXXX |
| UIMカード再発行 | AC24 | enum | 必須 | 希望する、希望しない | 希望する |
| 承諾事項チェック | F25 | boolean | 条件必須 | 機器情報不明時にチェック | true |
| ポイント利用 | F26 | enum | 任意 | 全ポイント、上限指定、利用しない | 利用しない |
| ポイント上限 | F27 | number | 条件必須 | 上限指定時のみ | 1000 |
| 決裁番号 | L47 | string | 任意 | D内部の決裁番号 | 関西法営020920号 |
| キッティング情報1 | A53 | text | 任意 | 個別設定情報 | 業務アプリID |
| キッティング情報2 | W53 | text | 任意 | 個別設定情報 | 初期パスワード |
| キッティング情報3 | A54 | text | 任意 | 個別設定情報 | 部署別設定 |
| キッティング情報4 | W54 | text | 任意 | 個別設定情報 | 備考 |

## 端末キッティング依頼書

| フィールド名 | セル番地 | 型 | 必須/任意 | 説明 | 入力例 |
|---|---|---|---|---|---|
| 申告日 | I8 | date | 必須 | 申告年月日 | 2026-04-14 |
| ご契約者名 | C9 | string | 必須 | 顧客企業名 | 株式会社サンプル |
| 部署名 | C11 | string | 必須 | 依頼元部署 | 情報システム部 |
| 依頼者 | H11 | string | 必須 | 企業管理者名 | 山田 太郎 |
| 電子メール | C13 | email | 必須 | 依頼者メール | user@example.jp |
| 連絡先 | H13 | tel | 必須 | 依頼者電話番号 | 0X0-XXXX-XXXX |
| 依頼書送付先 | D16 | email | 必須 | Kの受付メール | support@example.jp |
| サービスデスク住所 | D18 | text | 必須 | Kの住所と電話番号 | 〒XXX-XXXX 大阪府... |
| 依頼種別 | C23 | enum | 必須 | 利用者変更、再キッティング | 利用者変更 |
| 電話番号 | C25 | tel | 必須 | 対象端末の電話番号 | 0X0-XXXX-XXXX |
| 機種名 | H25 | string | 必須 | 対象端末の機種名 | iPad 2022 |
| キッティング情報1 | C27 | text | 任意 | 個別設定情報 | アプリID |
| キッティング情報2 | C29 | text | 任意 | 個別設定情報 | 初期パスワード |
| キッティング情報3 | C31 | text | 任意 | 個別設定情報 | 部署設定 |
| キッティング情報4 | C33 | text | 任意 | 個別設定情報 | 備考 |
| 送付先郵便番号 | C38 | string | 必須 | 返送先郵便番号 | 〒XXX-XXXX |
| 送付先住所 | C39 | text | 必須 | 返送先住所 | 大阪府大阪市... |
| 宛名 | C41 | string | 必須 | 返送先受取人 | 山田 太郎 |
| 電話番号 | C44 | tel | 必須 | 返送先電話番号 | 0X-XXXX-XXXX |

## 月次レポートスキーマ

| フィールド名 | 型 | 必須/任意 | 説明 | 入力例 |
|---|---|---|---|---|
| 対象月 | month | 必須 | 報告対象年月 | 2026-04 |
| 故障対応件数 | number | 必須 | 当月の故障対応件数 | 3 |
| 盗難紛失時の端末再貸与件数 | number | 必須 | 当月の再貸与件数 | 0 |
| 利用者変更件数 | number | 必須 | リクエストキッティング内訳 | 1 |
| 再キッティング件数 | number | 必須 | リクエストキッティング内訳 | 1 |
| 当月キッティング対応件数合計 | number | 必須 | 故障、盗難紛失、利用者変更、再キッティングの合計 | 5 |
| 契約期間内キッティング対応件数上限 | string | 必須 | 契約上限 | 100件/36か月 |
| 翌月以降キッティング対応件数上限 | string | 必須 | 残件数 | 95件/36か月 |
| 盗難紛失一次対応件数 | number | 任意 | 遠隔ロック、遠隔初期化 | 0 |
| 発見時対応件数 | number | 任意 | 遠隔ロック解除、パスワードリセット | 0 |
| 当月ヘルプデスク対応件数 | number | 任意 | 問い合わせ件数。詳細は折衝記録参照 | 5 |
| 契約期間内ヘルプデスク対応件数上限 | string | 任意 | 契約上限 | 50件/36か月 |
| 翌月以降ヘルプデスク対応件数上限 | string | 任意 | 残件数 | 45件/36か月 |
| 折衝記録添付 | boolean | 任意 | ヘルプデスク対応の詳細別紙有無 | true |

## お客様情報シートスキーマ

| フィールド名 | セル番地 | 型 | 必須/任意 | 説明 | 入力例 |
|---|---|---|---|---|---|
| No | B3 | number | 必須 | 管理番号 | 1 |
| 担当業務 | C3 | enum | 必須 | 企業管理者、報告書送付先など | 企業管理者 |
| 部署名 | D3 | string | 必須 | 所属部署 | 情報システム部 |
| 氏名 | E3 | string | 条件必須 | 企業管理者名 | 山田 太郎 |
| 所在地 | F3 | text | 必須 | 郵便番号・住所 | 〒XXX-XXXX 大阪府... |
| TEL | G3/H3 | tel | 任意 | 固定電話 | 0X-XXXX-XXXX |
| MB | G5/H5 | tel | 任意 | 携帯電話 | 0X0-XXXX-XXXX |
| メールアドレス | I3 | email | 条件必須 | 企業管理者メール | xxx-1@example.jp |
| 備考 | J3 | text | 任意 | 補足 | 報告書送付先 |
