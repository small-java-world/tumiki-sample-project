# ローカル開発環境構築タスク & プロンプト集

以下は、Rails + React + MySQL + MinIO + moto（Cognito 代替）を Tsumiki の Docker Compose テンプレートと設計書駆動 TDD で素早く構築するために、**生成 AI に投げるべき作業タスク**を 1 タスク＝1 プロンプトで分割し整理したものです。

---

## 前提

* プロジェクトルートは `myapp/`。
* Docker・Docker Compose・Node.js・Ruby on Rails CLI 等がローカルにインストール済み。
* 生成 AI には *毎タスク開始時* に「現在の作業ディレクトリ」と「既存ファイル構成のポイント」を 2‑3 行で伝えると精度が上がります。
* 依頼プロンプト → AI がコマンド or ファイル差分を返す →**チェックプロンプト**で AI 自身に検証させる、の 2 段サイクルを推奨。

---

## タスク一覧

| #  | タイトル                           | ゴール（成果物）                                               |
| -- | ------------------------------ | ------------------------------------------------------ |
| 1  | Tsumiki を導入                    | `.claude/commands/` 以下に Tsumiki コマンド一式                 |
| 2  | ディレクトリ雛形生成                     | `backend/`・`frontend/` フォルダと `.gitignore`, `README.md` |
| 3  | `docker-compose.yml` 作成        | 5 サービス（backend / frontend / db / minio / cognito）定義    |
| 4  | Rails Dockerfile & Gemfile 更新  | `backend/Dockerfile` 完成、Gemfile に追加 Gem                |
| 5  | MySQL / .env / database.yml 設定 | `backend/.env.development` & `config/database.yml` 完了  |
| 6  | ActiveStorage (MinIO) 設定       | `config/storage.yml` に `minio` 追加 & env 更新             |
| 7  | rack‑cors 初期化                  | `config/initializers/cors.rb` 作成                       |
| 8  | React アプリ初期化                   | CRA 雛形 + proxy or env 設定                               |
| 9  | moto (Cognito) 初期化コード          | `initializers/cognito.rb`, `db/seeds.rb` 追加            |
| 10 | RSpec / FactoryBot セットアップ      | `spec/` ディレクトリ & 設定完了                                  |
| 11 | Compose 起動確認                   | `docker compose up --build` が全サービス正常起動                 |
| 12 | Tsumiki 要件→テスト生成               | 要件定義 MD & 初回 Red テスト生成                                 |

---

## 各タスク詳細

> ### フォーマットについて
>
> * **依頼プロンプト** … AI に実際に投げる指示。
> * **結果チェックプロンプト** … AI に成果物を検証させる指示。
> * コード／YAML／差分などは **必ずコードブロック**で囲う。AI がそのままコピー→貼り付けできる。

---

### Task 1 : Tsumiki を導入

#### 依頼プロンプト

````markdown
プロジェクトルート（myapp）に Tsumiki を導入します。
以下のシェルコマンド列を提示してください。
- `npx tsumiki install` を実行して `.claude/commands` が生成されること
- `git add` まで含める
出力は「```bash」で始まるコードブロックのみでお願いします。
````

#### 結果チェックプロンプト

```markdown
次の条件を満たしているか確認してください。
1. `myapp/.claude/commands/` 配下に `kairo-` と `tdd-` で始まるファイルが 10 個以上ある
2. `package.json` もしくは `npm-shrinkwrap` に tsumiki の依存が追加された
判定と、満たさない場合の修正案を出力してください。
```

---

### Task 2 : ディレクトリ雛形生成

#### 依頼プロンプト

````markdown
以下を作成するシェルコマンドを提示してください。出力は ```bash ブロックのみ。
- `backend/` と `frontend/` フォルダ（中身は空で OK）
- 共通 `.gitignore`（node_modules, log/, tmp/, vendor/bundle 等を無視）
- `README.md` に「開発環境構築手順（後で追記予定）」の章を入れる
- `git add .`
````

#### 結果チェックプロンプト

```markdown
- `backend` と `frontend` ディレクトリが存在し、空であること
- `.gitignore` が `node_modules` と `log` を無視している
- `README.md` に「開発環境構築手順」という文字列が含まれている
不足があれば指摘と修正案を提示してください。
```

---

### Task 3 : `docker-compose.yml` を作成

#### 依頼プロンプト

````markdown
`myapp/docker-compose.yml` を新規作成してください。YAML 全文を ```yaml ブロックで出力。
要件
- services: backend, frontend, db(mysql:8.0), minio(bitnami/minio), cognito(motoserver/moto)
- backend: build ./backend, ports 3000:3000, depends_on db minio cognito
- frontend: node:18-alpine, ports 3001:3000, depends_on backend
- db: MYSQL_USER=myapp, MYSQL_PASSWORD=myapp_pass, MYSQL_DATABASE=myapp_development
- minio: ports 9000/9001, MINIO_ROOT_USER=minioadmin, MINIO_DEFAULT_BUCKETS=myapp-bucket
- cognito: port 5000, env MOTO_PORT=5000
- volumes: db-data, minio-data
````

#### 結果チェックプロンプト

```markdown
- 5 つの service 名（backend, frontend, db, minio, cognito）が存在
- backend の depends_on に db, minio, cognito が並ぶ
- minio の環境変数 `MINIO_DEFAULT_BUCKETS=myapp-bucket` が設定済み
- volumes セクションに db-data と minio-data が宣言
YAML 構文エラーの有無も報告してください。
```

---

### Task 4 : Rails Dockerfile & Gemfile 更新

#### 依頼プロンプト

````markdown
`backend/Dockerfile` を生成し、以下を満たしてください。
- FROM ruby:3.2-buster
- Node.js 18, default-mysql-client をインストール
- Gemfile/Gemfile.lock → bundle install → COPY .
- CMD ["bin/rails","server","-b","0.0.0.0","-p","3000"]

Gemfile に以下を追記して全文を提示してください。
```ruby
gem 'aws-sdk-s3'
gem 'rack-cors'
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end
````

````

#### 結果チェックプロンプト
```markdown
- Dockerfile の FROM 行が ruby:3.2-buster
- Dockerfile に Node.js インストールと "bundle install" がある
- Gemfile に aws-sdk-s3 と rack-cors が単独行で追加
- development,test グループに rspec-rails と factory_bot_rails
````

---

### Task 5 : MySQL / .env / database.yml 設定

#### 依頼プロンプト

````markdown
`backend/.env.development` と `backend/config/database.yml` を新規作成してください。
.env.development に:
  MYSQL_HOST=db
  MYSQL_USER=myapp
  MYSQL_PASSWORD=myapp_pass
  MYSQL_DATABASE=myapp_development
  AWS_ACCESS_KEY_ID=minioadmin
  AWS_SECRET_ACCESS_KEY=minioadmin
  AWS_REGION=us-east-1

database.yml development セクションは env 参照で mysql2 接続に。
両ファイル全文をそれぞれ ```dotenv と ```yaml ブロックで提示してください。
````

#### 結果チェックプロンプト

```markdown
- .env.development に 7 行すべてが存在する
- database.yml の development: で adapter が mysql2, host が ENV["MYSQL_HOST"]
不足していれば修正案を提示してください。
```

---

### Task 6 : ActiveStorage (MinIO) 設定

#### 依頼プロンプト

```markdown
`backend/config/storage.yml` に minio サービスを追加し、
`config/environments/development.rb` の `config.active_storage.service` を :minio に変更するパッチを提示してください。
storage.yml の minio には endpoint: http://minio:9000 と force_path_style: true を含めてください。
```

#### 結果チェックプロンプト

```markdown
- storage.yml に minio: service: S3 が存在し endpoint が http://minio:9000 か
- development.rb に `config.active_storage.service = :minio` が追加されているか
```

---

### Task 7 : rack‑cors 初期化

#### 依頼プロンプト

````markdown
Gemfile に rack-cors は追加済みなので、`backend/config/initializers/cors.rb` を新規作成してください。
内容
```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete, :options]
  end
end
````

ファイル全文を提示してください。

````

#### 結果チェックプロンプト
```markdown
cors.rb が存在し、origins に http://localhost:3001 が指定されているか確認。
````

---

### Task 8 : React アプリ初期化

#### 依頼プロンプト

```markdown
`frontend/` に create-react-app を使って React プロジェクトを初期化するシェルコマンド列を提示してください。
- `npx create-react-app .`
- `package.json` に "proxy": "http://localhost:3000" を追加する jq コマンド
- `.env.development` に `REACT_APP_API_BASE_URL=http://localhost:3000`
- `git add .`
```

#### 結果チェックプロンプト

```markdown
- frontend/package.json に "proxy": "http://localhost:3000" がある
- frontend/.env.development に `REACT_APP_API_BASE_URL` がある
- src/App.js と src/index.js が存在
```

---

### Task 9 : moto (Cognito) 初期化コード

#### 依頼プロンプト

````markdown
`backend/config/initializers/cognito.rb` と `backend/db/seeds.rb` を作成してください。

cognito.rb
```ruby
require 'aws-sdk-cognitoidentityprovider'
CognitoClient = Aws::CognitoIdentityProvider::Client.new(
  region: ENV.fetch('AWS_REGION'),
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  endpoint: 'http://cognito:5000'
)
````

seeds.rb

```ruby
pool = CognitoClient.create_user_pool(pool_name: ENV.fetch('COGNITO_USER_POOL_ID', 'local_pool'))
puts "Created user pool #{pool.user_pool.id}"
```

ファイル全文を提示してください。

````

#### 結果チェックプロンプト
```markdown
- cognito.rb に Aws::CognitoIdentityProvider::Client.new があり endpoint が http://cognito:5000
- seeds.rb で create_user_pool が呼ばれている
````

---

### Task 10 : RSpec / FactoryBot セットアップ

#### 依頼プロンプト

```markdown
RSpec を初期化し、FactoryBot の設定ファイルを作成するシェルコマンド列をください。
- `rails g rspec:install`
- `spec/support/factory_bot.rb` に `FactoryBot.configure` を書く
- `.rspec` に `--format documentation` を追加
- `git add .`
```

#### 結果チェックプロンプト

```markdown
- spec/ ディレクトリが生成され、spec/spec_helper.rb が存在
- spec/support/factory_bot.rb に FactoryBot.configure 行がある
- .rspec に --format documentation が含まれる
```

---

### Task 11 : Compose 起動確認

#### 依頼プロンプト

```markdown
docker compose up --build を実行し、5 サービスが healthy になるまでのログ確認手順を示してください。
成功判定基準と失敗時の代表的な対処法を箇条書きで提示してください。
```

#### 結果チェックプロンプト

```markdown
- backend, frontend, db, minio, cognito が STATE=running か healthy
- backend ログに "Listening on tcp://0.0.0.0:3000"
- frontend ログに "Compiled successfully"
問題があればコンテナ別にエラーログ先頭 30 行を出力してください。
```

---

### Task 12 : Tsumiki 要件→テスト生成

#### 依頼プロンプト

```markdown
Claude Code で `/kairo-requirements` を実行し、Todo アプリの要件定義を作成してください。
続けて `/tdd-testcases` を実行し、最初の Red テストを `spec/` に生成してください。
作業中に求められる回答入力例もあわせて提示してください。
```

#### 結果チェックプロンプト

```markdown
- docs/spec/ 配下に要件定義 Markdown が生成されている
- spec/ 配下に *_spec.rb が追加され、そのテストが Red (失敗) 状態
ファイル名と失敗メッセージを一覧で報告してください。
```

---

## 運用 Tips

1. **タスク単位で Git コミット**
   `git commit -m "Task 3: add docker-compose.yml"` のように細かく区切るとリカバリ容易。
2. **AI へのコンテキスト提供は最小で OK**
   毎回「現ディレクトリ」と「直近で生成・変更したファイル」を 2‑3 行で伝えるだけで、ほぼ意図を誤らない。
3. **長いファイルは unified diff 指示が安全**
   `@@ -1,5 +1,9 @@` 形式でパッチを依頼すると既存行を壊しにくい。
4. **チェックプロンプトは “事実のみ回答” を強制**
   OK/NG と修正ポイントだけ返させるとログが読みやすく、そのまま次の依頼に流用しやすい。

---

以上の Markdown をそのまま `setup_tasks.md` として保存し、プロジェクト README とは別に **AI ドリブン開発用の手引き** として扱ってください。

   cd D:\tsumiki\sample\myapp
 docker compose build backend
 docker compose up --build

 Get-Content backend\Dockerfile

 docker compose port backend 3000
docker compose port frontend 3001
docker compose port db 3306
docker compose port minio 9000
docker compose port cognito 5000
