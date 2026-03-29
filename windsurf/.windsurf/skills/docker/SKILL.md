---
name: docker
description: Dockerfile/Composeを作る・最適化する
user-invocable: true
disable-model-invocation: true
---
# Docker設定生成

プロジェクトに合ったDockerfile / docker-compose.yml / .dockerignore を作る。

## 手順

### ステップ1: 技術スタックの検出
- `package.json` → Node.js プロジェクト
- `requirements.txt` / `pyproject.toml` → Python プロジェクト
- `go.mod` → Go プロジェクト
- `Gemfile` → Ruby プロジェクト
- 複数のサービスがある場合(モノレポ等)は、それぞれにDockerfileを作る

### ステップ2: Dockerfileの生成(マルチステージビルド)

#### Node.js (Next.js / Express等)
```dockerfile
FROM node:20-alpine AS base
WORKDIR /app
COPY package.json package-lock.json ./

FROM base AS deps
RUN npm ci --only=production

FROM base AS build
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
USER appuser
EXPOSE 3000
CMD ["node", "dist/index.js"]
```
- Next.jsの場合は `standalone` 出力モードを使う(`next.config.js` に `output: 'standalone'` を追加)
- `CMD` はプロジェクトのstartスクリプトに合わせる

#### Python (Flask / FastAPI等)
```dockerfile
FROM python:3.12-slim AS base
WORKDIR /app
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

FROM base AS deps
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

FROM deps AS runner
COPY . .
USER appuser
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
```
- FastAPIの場合: `CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]`
- `pip install --no-cache-dir` でキャッシュを消してイメージを小さくする

#### Go
```dockerfile
FROM golang:1.22-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/app .

FROM gcr.io/distroless/static-debian12 AS runner
COPY --from=build /bin/app /bin/app
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/bin/app"]
```
- Goはバイナリ1つにできるので、distrolessイメージで極小にする

### ステップ3: セキュリティの原則
- rootユーザーで実行しない。必ず `USER` 命令で非rootユーザーに切り替える
- ベースイメージは `-alpine` か `-slim` を使う(通常版は不要なパッケージが多い)
- `latest` タグは使わない。バージョンを固定する(例: `node:20-alpine`)
- ビルドに使った依存関係(devDependencies等)を最終イメージに含めない(マルチステージで分離)
- `COPY . .` の前に `.dockerignore` で不要ファイルを除外する

### ステップ4: .dockerignore の生成
以下の内容で `.dockerignore` を作る:
```
node_modules
.git
.gitignore
.env*
*.md
.vscode
.idea
dist
build
coverage
test-results
__pycache__
*.pyc
.pytest_cache
```
- プロジェクトの `.gitignore` も参考にする

### ステップ5: docker-compose.yml の生成
プロジェクトが外部サービス(DB, キャッシュ等)を使う場合に生成する。

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  db_data:
  redis_data:
```

- DBの種類に応じて変更する:
  - MySQL: `image: mysql:8`, `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`
  - MongoDB: `image: mongo:7`, ポート `27017`
- 使わないサービスは削除する
- 本番用とは別に `docker-compose.yml` は開発用として使う
- `depends_on` と `healthcheck` で起動順序を制御する

### ステップ6: 確認事項
- `docker build -t myapp .` でビルドできるか確認する
- `docker compose up` で全サービスが起動するか確認する
- アプリケーションにアクセスできるか確認する
- イメージサイズが適切か確認する(`docker images` で確認)。Node.jsなら200MB以下、Goなら50MB以下が目安
