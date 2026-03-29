---
trigger: glob
globs: "**/*.{ts,tsx,js,jsx,py}"
description: コーディング規約
---
# コーディング規約

- 使用言語の strict mode を有効にする (TypeScript: strict, Python: mypy strict 等)
- 型安全: 曖昧な型 (any, Object 等) は避ける。具体的な型を使う
- ファイル名: 言語の慣例に従う (React: PascalCase、Python: snake_case 等)
- インポート順序: 外部 → 内部 → 型 → スタイル
- 未使用のインポート・変数は即削除
- 関数は短く。1つの関数は1つの仕事だけ
