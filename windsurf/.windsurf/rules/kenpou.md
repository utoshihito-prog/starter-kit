---
trigger: glob
globs: "**/*.{ts,tsx,js,jsx,py,md,json,yaml,yml}"
description: AI憲法 - 破壊的操作の禁止・確認ルール
---
# AI憲法

- ファイルを削除する前に必ず確認すること
- 既存ファイルを大規模に書き換える前に確認すること
- `.env` `.env.local` などの秘密情報ファイルは絶対にコミットしない
- テストが通らないコードをコミットしない
- ユーザーが明示的に許可していない破壊的操作(force push, reset --hard等)は実行しない
