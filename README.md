# Vibe Coding Starter Kit — Terminal Edition

ターミナル中級者向け、AI コーディングを **爆速 × 高品質** で進めるためのスターターキット。

- **対応エディタ**: Claude Code / Codex CLI / Gemini CLI
- **設計**: ライフサイクル別の厳選15スキル + `/auto` オーケストレーター
- **方針**: ゴールまで自動進行。要所だけ人間が確認する

---

## クイックスタート

```bash
# 1. キットをクローン
git clone https://github.com/utoshihito-prog/starter-kit.git
cd starter-kit

# 2. 新規プロジェクトを作る
bash setup.sh my-app claude-code
#   または対話モード: bash setup.sh my-app

# 3. エディタ起動
cd my-app
claude     # or: codex / gemini

# 4. Auto Mode で進める
/auto ログイン機能を作りたい
```

既存プロジェクトに後入れする場合:

```bash
bash setup.sh ../existing-project claude-code
```

---

## 15スキル（ライフサイクル別）

| Phase | スキル | 用途 |
|-------|--------|------|
| **Mode** | `/auto` | 依頼を分類し、適切なスキルを順に呼ぶ。要所で確認 |
| **Define** | `/spec` | 仕様書を作る |
| **Plan** | `/plan` | タスクに分解する |
| **Build** | `/tdd` | テストファースト実装 |
|  | `/refactor` | 振る舞い保持で整理 |
| **Verify** | `/diagnose` | バグの原因特定と修正案 |
|  | `/test-gen` | テスト自動生成 |
| **Review** | `/review` | 重要度別レビュー |
|  | `/security-check` | OWASP系セキュリティ点検 |
|  | `/polish` | コード簡素化 |
| **Ship** | `/commit` | 規約準拠コミット |
|  | `/pr` | PR作成 |
|  | `/land` | test → commit → push 一括 |
| **Ops** | `/handoff` | 引き継ぎ資料を作る |
|  | `/resume` | 引き継ぎから再開する |

---

## `/auto` の挙動

```
1. 依頼を分類 (新機能 / バグ / リファクタ / レビュー / 出荷 / 引き継ぎ)
2. 対応スキルを順に呼ぶ
3. 以下では必ず手を止めてユーザー確認:
     - 破壊的操作 (削除 / force push / DB変更)
     - 設計の分岐 (技術選定 / スキーマ / 認証・課金)
     - スコープ外 / テスト失敗
     - 各フェーズ完了時
```

詳細は `.claude/skills/auto/SKILL.md` を参照。

---

## ディレクトリ構成

```
starter-kit/
├── setup.sh                    # セットアップスクリプト
├── shared/                     # 全エディタ共通 (docs, roles, scripts, prompts)
├── editors-claude/             # Claude Code 用 (.claude/)
├── editors-codex/              # Codex CLI 用 (.agents/, .codex/)
└── editors-gemini/             # Gemini CLI 用 (.gemini/)
```

各エディタディレクトリには **同じ15スキル** がエディタ固有のフォーマットで格納されています。

---

## チーム開発・引き継ぎ

```
/handoff           # 現状をまとめて HANDOFF.md に書き出す
/resume            # 別の人/AI が HANDOFF.md を読んで再開
```

役割分担 (backend / frontend / architect / designer) は `shared/roles/` に定義。

---

## カスタマイズ

- **ルールを足す**: `editors-claude/.claude/rules/` に Markdown を追加
- **スキルを足す**: `editors-claude/.claude/skills/<name>/SKILL.md` を作る
- **コマンドを変える**: `shared/docs/` 配下のテンプレートを編集

---

## ライセンス

MIT
