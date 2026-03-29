---
name: ci-cd
description: pushしたら自動テスト＆デプロイの設定を作る
user-invocable: true
disable-model-invocation: true
---
# CI/CD設定生成

GitHub Actionsのワークフローを自動生成する。テスト・ビルド・デプロイを自動化する。

## 手順

### ステップ1: プロジェクトの情報を収集する
- `package.json` の `scripts` からコマンドを検出する:
  - テスト: `test`, `test:unit`, `test:e2e`
  - ビルド: `build`
  - リント: `lint`, `lint:fix`
  - 型チェック: `type-check`, `typecheck`
- `pyproject.toml` / `requirements.txt` / `go.mod` 等も確認する
- Node.jsのバージョンを `.node-version`, `.nvmrc`, `package.json.engines` から検出する
- Pythonのバージョンを `pyproject.toml` や `.python-version` から検出する

### ステップ2: CIワークフローの生成 (.github/workflows/ci.yml)

#### Node.js プロジェクトの場合
```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check

  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      - run: npm ci
      - run: npm test

  build:
    runs-on: ubuntu-latest
    needs: [lint, test]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run build
```

#### Python プロジェクトの場合
```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'
      - run: pip install -r requirements.txt
      - run: pip install -r requirements-dev.txt
      - run: pytest --cov
      - run: ruff check .
```

### ステップ3: キャッシュ戦略
- **npm**: `actions/setup-node` の `cache: 'npm'` で自動キャッシュ(package-lock.jsonベース)
- **pnpm**: `actions/setup-node` + `pnpm/action-setup@v2` を組み合わせる
- **pip**: `actions/setup-python` の `cache: 'pip'` で自動キャッシュ
- **Go**: `actions/setup-go` の `cache: true` で自動キャッシュ
- **Playwright**: ブラウザバイナリのキャッシュを追加する
  ```yaml
  - uses: actions/cache@v4
    with:
      path: ~/.cache/ms-playwright
      key: playwright-${{ hashFiles('package-lock.json') }}
  ```
- キャッシュが効いているか `Post actions/setup-node` のログで確認する

### ステップ4: マトリックステスト
- 複数のランタイムバージョンでテストする(上記例の通り)
- OS別テストが必要な場合: `runs-on: ${{ matrix.os }}` + `matrix: { os: [ubuntu-latest, macos-latest] }`
- マトリックスが多すぎると時間がかかる。必要最小限にする

### ステップ5: デプロイワークフローの生成 (.github/workflows/deploy.yml)

#### Vercel (フロントエンド)
```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

#### Railway
```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: bervProject/railway-deploy@main
        with:
          railway_token: ${{ secrets.RAILWAY_TOKEN }}
          service: ${{ secrets.RAILWAY_SERVICE_ID }}
```

#### Fly.io
```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

### ステップ6: シークレットの管理
- ワークフロー内でシークレットが必要な場合:
  - `${{ secrets.名前 }}` で参照する
  - 値はGitHubの Settings → Secrets and variables → Actions で設定する
- 必要なシークレットの一覧をユーザーに伝える
- シークレットをログに出力しないよう注意する(`echo` で表示しない)
- PRのワークフローでは `pull_request` イベントだとforkからのPRでシークレットにアクセスできない点に注意

### ステップ7: ステータスバッジ
- READMEにCIのステータスバッジを追加することを提案する:
  ```markdown
  ![CI](https://github.com/ユーザー名/リポ名/actions/workflows/ci.yml/badge.svg)
  ```

### ステップ8: 確認してからファイルを作成
- 生成する全ファイルの内容をユーザーに見せる
- ユーザーがOKしたらファイルを作成する
- `.github/workflows/` ディレクトリが存在しなければ作る
- 既にワークフローファイルがある場合は上書きしていいか確認する

### よくある問題と対処
- テストがCIだけで落ちる → 環境変数の設定漏れ、タイムゾーンの違い、DB接続設定を確認
- キャッシュが効かない → lockfileの変更を確認。hashが変わるとキャッシュが無効になる
- デプロイが失敗する → シークレットが正しく設定されているかGitHubの設定画面で確認
