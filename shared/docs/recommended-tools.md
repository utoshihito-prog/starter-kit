# 推奨ツール

必須ではない。必要に応じて導入する。

## MCP（エージェントに目と手を与える）
- **Exa**: Web検索。最新のライブラリドキュメントを取得
  `claude mcp add exa "https://mcp.exa.ai/mcp?apiKey=YOUR_KEY"`
- **Context7**: ライブラリの最新APIリファレンスを取得
  `claude mcp add context7 npx @upstash/context7-mcp@latest`
- **Chrome DevTools**: ブラウザ操作、スクリーンショット、コンソール確認
  `claude mcp add --scope user chrome-devtools npx @chrome-devtools/mcp@latest`

## 音声入力
- **Wispr Flow** (Mac): fn長押しで音声入力。タイプの5倍速
- タイピングだと省略しがち → 音声だと文脈を全部話せる → 出力品質が上がる

## Claude Code コマンド
- `/cost`: トークン消費量を確認
- `/compact`: コンテキストを手動圧縮
- `/clear`: セッションをリセット
- `/memory`: 読み込まれている設定を確認
- `/status`: モデル、コンテキスト使用率
