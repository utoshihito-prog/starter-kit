---
name: e2e
description: ブラウザを自動で動かしてテストする
user-invocable: true
disable-model-invocation: true
---
# E2Eテスト (Playwright)

ブラウザを自動で操作して、画面の動作をテストする。

## 手順

### ステップ1: Playwrightのセットアップ
- `package.json` の `devDependencies` に `@playwright/test` があるか確認する
- なければインストールする:
  ```
  npm install -D @playwright/test
  npx playwright install chromium
  ```
- `playwright.config.ts` が存在するか確認する。なければ以下の内容で生成する:
  ```typescript
  import { defineConfig, devices } from '@playwright/test'
  export default defineConfig({
    testDir: './e2e',
    timeout: 30000,
    retries: process.env.CI ? 2 : 0,
    use: {
      baseURL: 'http://localhost:3000',
      screenshot: 'only-on-failure',
      trace: 'on-first-retry',
    },
    projects: [
      { name: 'desktop', use: { ...devices['Desktop Chrome'] } },
      { name: 'mobile', use: { ...devices['iPhone 14'] } },
    ],
    webServer: {
      command: 'npm run dev',
      port: 3000,
      reuseExistingServer: !process.env.CI,
    },
  })
  ```
- `webServer.command` と `port` はプロジェクトの設定に合わせて調整する

### ステップ2: テストファイルの命名と配置
- テストディレクトリ: `e2e/` (プロジェクトルート直下)
- ファイル命名: `e2e/<機能名>.spec.ts` (例: `e2e/login.spec.ts`, `e2e/user-registration.spec.ts`)
- Page Objectファイル: `e2e/pages/<ページ名>.page.ts` (例: `e2e/pages/login.page.ts`)

### ステップ3: セレクター戦略
- 最優先: `data-testid` 属性を使う (例: `page.getByTestId('submit-button')`)
- 次に: Playwrightのロケーター (例: `page.getByRole('button', { name: '送信' })`)
- 次に: テキストで探す (例: `page.getByText('ログイン')`)
- 最後の手段: CSSセレクター (例: `page.locator('.submit-btn')`) - これはなるべく避ける
- テスト対象の要素に `data-testid` がなければ、コード側に追加することを提案する

### ステップ4: Page Object Modelで書く
- 各ページの操作をクラスにまとめる:
  ```typescript
  // e2e/pages/login.page.ts
  import { Page } from '@playwright/test'
  export class LoginPage {
    constructor(private page: Page) {}
    async goto() { await this.page.goto('/login') }
    async login(email: string, password: string) {
      await this.page.getByTestId('email').fill(email)
      await this.page.getByTestId('password').fill(password)
      await this.page.getByTestId('submit').click()
    }
    async getErrorMessage() {
      return this.page.getByTestId('error-message').textContent()
    }
  }
  ```
- テストコードはPage Objectを使って書く

### ステップ5: テストシナリオの作成
以下のカテゴリでシナリオを作成する:
1. **ハッピーパス**: 正常な操作フロー(ログイン成功、フォーム送信成功等)
2. **エラーケース**: バリデーションエラー、404ページ、サーバーエラー表示
3. **ナビゲーション**: ページ遷移、戻るボタン、リンク先
4. **フォーム**: 入力、バリデーション、送信、リセット
5. **認証フロー**: ログイン→認証が必要なページ→ログアウト
6. **レスポンシブ**: モバイルとデスクトップで同じテストを実行(configのprojectsで設定済み)

### ステップ6: 認証が必要なテストの対処
- ログイン状態を保存して再利用する:
  ```typescript
  // e2e/auth.setup.ts でログインしてstorageStateを保存
  // 各テストファイルで storageState を読み込む
  ```
- playwright.config.ts の `projects` にdependenciesを設定:
  ```typescript
  { name: 'setup', testMatch: /.*\.setup\.ts/ },
  { name: 'tests', dependencies: ['setup'], use: { storageState: '.auth/user.json' } },
  ```

### ステップ7: 失敗時のデバッグ設定
- `screenshot: 'only-on-failure'` でスクリーンショットを自動保存(config済み)
- `trace: 'on-first-retry'` でトレースファイルを保存(config済み)
- スクリーンショットの保存先: `test-results/` ディレクトリ
- トレースの確認: `npx playwright show-trace test-results/trace.zip`
- `test-results/` を `.gitignore` に追加する

### ステップ8: テストの実行
- 全テスト: `npx playwright test`
- 特定ファイル: `npx playwright test e2e/login.spec.ts`
- UIモード(デバッグ用): `npx playwright test --ui`
- ヘッドフルモード(ブラウザ表示): `npx playwright test --headed`
- 結果レポート: `npx playwright show-report`

### 注意事項
- テストは互いに独立させる。テスト間で状態を共有しない
- `waitForTimeout` は使わない。`waitForSelector` や `waitForResponse` を使う
- CIでは `retries: 2` にして、不安定なテストの影響を減らす
- テストデータはテスト内で作成・削除する。既存データに依存しない
