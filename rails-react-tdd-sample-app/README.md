# rails-react-tdd-sample-app

Rails + React のTDD題材サンプルアプリ（最小構成）。Docker Composeで起動し、/health による疎通とUT（Vitest/RSpec）がGreenの初期状態です。

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![React](https://img.shields.io/badge/React-18-blue.svg)](https://reactjs.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://mysql.com)
[![Tsumiki](https://img.shields.io/badge/Tsumiki-AI%20Driven-green.svg)](https://github.com/small-java-world/tsumiki-sample-project)

## 🌐 railsとreactのtddの題材のサンプルアプリ（TDD対象の最小サービス）

このディレクトリ（`rails-react-tdd-sample-app/`）は、「railsとreactのtddの題材のサンプルアプリ」のソースです。以降の開発は、Tsumiki と Claude Code を用いた TDD の Red→Green→Refactor サイクルで進めます。

### 🚀 起動
```bash
cd rails-react-tdd-sample-app
docker compose up -d --build
```

起動後の確認:
- Backend: http://localhost:3000/health（JSONが返ればOK）
- Frontend: http://localhost:3001
- MySQL: localhost:3306（DB: `myapp_development`, ユーザー: `myapp` / `myapp_pass`）
- MinIO Console: http://localhost:9003（`minioadmin`/`minioadmin`）

### 🧪 TDD フロー（Tsumiki + Claude Code）
作業は常に `rails-react-tdd-sample-app/` をカレントにして実行します。

1) 失敗テスト生成（Red）
```bash
claude -p "/tdd-red サービス詳細の初期表示を検証するテストを生成し、実行して Red を確認してください"
```

2) 最小実装（Green）
```bash
claude -p "/tdd-green 直前の Red を最小変更で通してください"
```

3) リファクタ（Refactor）
```bash
claude -p "/tdd-refactor 重複排除・命名改善・構成の整理を提案し適用してください"
```

必要に応じて要件の明確化:
```bash
claude -p "/tdd-requirements railsとreactのtddの題材のサンプルアプリのサービス詳細画面の機能要件を優先度順に整理してください"
```

#### ✅ 最短ゴール（Green確認）
- Backend（RSpec）: `docker compose exec backend bash -lc "RAILS_ENV=test bundle exec rspec --format documentation"`
- Frontend（Vitest）: `docker compose exec frontend sh -lc "npm test -- --run"`

> 互換メモ: Node 18 + vitest@^1.6.0 で確認済み。設定ファイルは `vitest.config.mts` を使用。

## 📋 プロジェクト概要

このプロジェクトは、**Tsumiki AI開発ツール** と **Serena MCP (LSP ベースセマンティックエンジン)** を組み合わせたモダン Web 開発環境テンプレートです。Docker Compose で必要なサービスを簡単に起動し、AI 支援開発を体験できます。

### 🎯 特徴

- **🤖 AI駆動開発**: Tsumiki + Serena によるセマンティック AI 支援開発
- **📦 コンテナ化**: Docker Compose で統一された開発環境
- **⚡ 軽量構成**: 必要最小限のサービス構成
- **🗄️ 完全DB**: MySQL + MinIO S3 互換ストレージ
- **🔧 拡張可能**: Rails API 等のバックエンド追加可能
- **🔀 並行開発**: Git Worktree で複数ブランチを同時進行
- **📝 日本語対応**: 包括的な日本語ドキュメント

## 🛠️ 技術スタック

### 🟢 **現在動作中**
- **React 18 + Node.js 18**（Frontend, Vitest済）
- **Rails 7 API**（/health 実装・RSpec済）
- **MySQL 8.0**（DB接続確認済）
- **MinIO**（S3互換）
- **moto (Cognito代替)**
- **Docker / Docker Compose**

### 🤖 **AI開発支援**
- **Tsumiki** - AI駆動開発コマンド集（21種類）
- **Claude Code CLI** - ターミナルベース AI 開発
- **Serena MCP Server** - LSP ベースのセマンティック検索 / 編集
- **手動参照** - Markdown ファイル直接参照

### 🚧 **開発予定**
- REST API拡充（業務ドメイン）
- 認証（moto / Cognito代替）
- RSpec/FactoryBotによるUT強化

## 🚀 クイックスタート

### 前提条件

- **Docker** & **Docker Compose** インストール済み
- **Git** インストール済み  
- **VS Code** (推奨)

### 1. リポジトリクローン

```bash
git clone https://github.com/small-java-world/tsumiki-sample-project.git
cd tsumiki-sample-project
```

### 2. 開発環境起動

```bash
# 全サービス起動
docker compose up --build

# バックグラウンド起動
docker compose up -d --build
```

### 3. (任意) Serena MCP サーバー有効化
```bash
# uv が未インストールの場合
curl -LsSf https://astral.sh/uv/install.sh | sh

# Serena を Claude Code に登録
claude mcp add serena -s project -- uvx --from git+https://github.com/oraios/serena \
  serena start-mcp-server --context ide-assistant --project $(pwd)
```

### 4. サービス確認

| サービス | URL | ステータス | 説明 |
|---------|-----|-----------|------|
| **React Frontend** | http://localhost:3001 | ✅ **動作中** | Webアプリケーション |
| **MinIO Console** | http://localhost:9003 | ✅ **動作中** | ストレージ管理画面 |
| **MySQL** | localhost:3306 | ✅ **動作中** | データベース接続 |
| **Rails Backend** | http://localhost:3000/health | ✅ **動作中** | /health で疎通確認 |

## 🔀 Git Worktree 並列開発 (概要)

Git Worktree を利用すると、**複数のブランチを別フォルダにチェックアウト** して並行開発が可能です。各 Worktree は独立したコンテナ・DB を持てるため、複数機能やバグフィックスを同時に進めてもビルド／テストが競合しません。

```bash
# 例) 機能ブランチを Worktree として追加
# (bare リポジトリ myapp-bare/ を作成済みと仮定)
cd myapp-bare

git worktree add -b feature/payment ../feature-payment   # 新規ブランチ作成 + チェックアウト
cd ../feature-payment
cp -p ../env.template .env && sed -i 's/COMPOSE_PROJECT_NAME=.*/COMPOSE_PROJECT_NAME=myapp_payment/' .env

# VS Code で Worktree を開き "Reopen in Container"
code .
```

詳しい手順やトラブルシューティングは [`docs/worktree-development.md`](docs/worktree-development.md) を参照してください。

---

## 📁 ディレクトリ構成

```
rails-react-tdd-sample-app/
├── .claude/commands/          # ✅ Tsumiki AIコマンド集（21個）
│   ├── kairo-*.md            # 要件→実装フロー
│   ├── tdd-*.md              # テスト駆動開発
│   └── rev-*.md              # レビュー系コマンド
├── frontend/                  # ✅ React SPA（動作中）
│   ├── package.json          # Node.js依存関係
│   ├── src/                  # Reactソースコード
│   │   ├── App.jsx           # メインコンポーネント
│   │   └── index.js          # エントリーポイント
│   └── public/               # 静的ファイル
├── backend/                   # ✅ Rails API（/health実装済み）
│   ├── Dockerfile            # Rails用Dockerファイル
│   ├── Gemfile               # Ruby依存関係
│   └── spec/                 # RSpec（/healthのrequest spec）
├── docker-compose.yml         # ✅ サービス定義
├── .mcp.json                # Serena MCP 設定ファイル
├── .gitignore                # Git除外設定
└── README.md                 # このファイル
```

## 🤖 Tsumiki AI コマンド活用

> 💡 Serena MCP を導入すると、Tsumiki コマンドのコード検索・編集が LSP 由来のセマンティック操作に置き換わり、トークンコストを大幅に削減できます。

### 🎯 **主要コマンド（21種類利用可能）**

```bash
# 📋 要件定義→設計→実装フロー
.claude/commands/kairo-requirements.md    # 要件整理
.claude/commands/kairo-design.md          # 設計作成  
.claude/commands/kairo-implement.md       # 実装支援

# 🧪 テスト駆動開発（TDD）
.claude/commands/tdd-requirements.md      # テスト要件
.claude/commands/tdd-red.md               # Red（失敗テスト）
.claude/commands/tdd-green.md             # Green（実装）
.claude/commands/tdd-refactor.md          # Refactor（リファクタ）

# 📊 レビュー・検証
.claude/commands/rev-requirements.md      # 要件レビュー
.claude/commands/rev-design.md            # 設計レビュー
.claude/commands/rev-specs.md             # 仕様書レビュー
```

### 🛠️ **AI開発ツール使用方法**

**Claude Code CLI**（Tsumiki公式対応・推奨）
```bash
# インストール
npm install -g @anthropic-ai/claude-code

# ログイン
claude login

# Tsumikiコマンド実行
claude -p "/tdd-red テストケース名"
claude -p "/kairo-requirements 新機能"
claude -p "/rev-design 設計レビュー"
```

**Cursor CLI**（ターミナルからTsumikiを実行）
```bash
# インストール
curl https://cursor.com/install -fsS | bash

# 使い方（スラッシュコマンド）
# 例: /tdd-red でRed作成
# 詳細は README.cursor.md を参照
```

**手動でTsumikiコマンド参照**
```bash
# コマンド一覧確認
ls .claude/commands/

# 特定コマンド内容確認
cat .claude/commands/tdd-red.md
cat .claude/commands/kairo-requirements.md
```

**⚠️ 注意**: VS Code拡張機能「Cline」は削除済みです。Claude Code CLIまたは手動参照をご利用ください。

## 🌳 Git Worktree 開発環境

### 🎯 **Worktreeとは**
Git worktreeを使用することで、複数のブランチを同時に異なるディレクトリで作業できます。機能開発・バグ修正・リリース作業を並行して効率的に進められます。

### 🚀 **セットアップ方法**

**Windows (PowerShell):**
```powershell
# worktree環境セットアップ
.\scripts\setup-worktree.ps1

# ヘルパースクリプト使用
.\scripts\worktree-helper.ps1 feature user-auth
.\scripts\worktree-helper.ps1 hotfix critical-bug
.\scripts\worktree-helper.ps1 status
```

**Linux/Mac (Bash):**
```bash
# 実行権限付与
chmod +x scripts/setup-worktree.sh scripts/worktree-helper.sh

# worktree環境セットアップ
./scripts/setup-worktree.sh

# ヘルパースクリプト使用
./scripts/worktree-helper.sh feature user-auth
./scripts/worktree-helper.sh hotfix critical-bug
./scripts/worktree-helper.sh status
```

### 📁 **Worktree構造**
```
project-root/
├── myapp-bare/              # ベアリポジトリ
├── main/                    # mainブランチ作業ディレクトリ
├── develop/                 # developブランチ作業ディレクトリ
├── feature-user-auth/       # 機能開発ディレクトリ
├── hotfix-critical-bug/     # 緊急修正ディレクトリ
└── feature-example/         # サンプル機能ディレクトリ
```

### 🛠️ **開発ワークフロー**

**手動Worktreeセットアップ**:
```bash
# 1. ベアリポジトリ作成
cd ..
git clone --bare <remote-url> myapp-bare
cd myapp-bare

# 2. Worktree作成
git worktree add ../main main
git worktree add -b develop ../develop
git worktree add -b feature/payment-system ../feature-payment-system

# 3. 開発作業
cd ../feature-payment-system
git add .
git commit -m "feat: add payment integration"
git push origin feature/payment-system

# 4. 全worktreeステータス確認
git worktree list
```

**PowerShellヘルパー** (scripts/worktree-helper.ps1):
```powershell
# 機能ブランチ作成
.\scripts\worktree-helper.ps1 feature payment-system

# ステータス確認
.\scripts\worktree-helper.ps1 status
```

## 🔄 GitHub Workflow

### 🚀 **CI/CDパイプライン** ✅
プッシュ・プルリクエスト時に自動実行：

```yaml
✅ Frontend Tests    # React テスト・ビルド・カバレッジ
✅ Docker Tests      # サービス起動・接続確認・Worktree対応
✅ Security Check    # Trivy脆弱性スキャン・ESLint
🚀 Deploy           # 本番環境デプロイ（mainブランチのみ）
📢 Notifications    # 実行結果通知
```

### 🤖 **Dependabot自動更新** ✅
- **毎週月曜日 09:00**: npm依存関係更新（frontend）
- **毎週火曜日 09:00**: Docker イメージ更新  
- **毎週水曜日 09:00**: GitHub Actions更新
- **自動マージ**: パッチ・マイナーバージョン
- **自動承認**: Dependabot PRの自動処理

### 📋 **Issue・PRテンプレート** ✅
- 🐛 **Bug Report**: 環境情報・再現手順・スクリーンショット
- ✨ **Feature Request**: 問題定義・受け入れ基準・実装ノート
- 🔄 **Pull Request**: チェックリスト・テスト確認・AI開発ノート

### 🏗️ **本番環境対応** ✅
- **docker-compose.prod.yml**: 本番環境設定
- **env.template**: 環境変数テンプレート
- **Traefik対応**: リバースプロキシ・SSL終端
- **ボリューム永続化**: プロダクションデータ保護

## 🔧 開発コマンド

### Docker操作

```bash
# サービス起動
docker compose up --build

# 特定サービスのみ
docker compose up backend db minio

# ログ確認
docker compose logs backend
docker compose logs frontend

# コンテナ状況確認
docker compose ps

# 停止・クリーンアップ
docker compose down
docker compose down --volumes  # ボリュームも削除
```

### 個別サービステスト

```bash
# ✅ Frontend（React）ログ追跡（開発サーバーは常時起動）
docker compose logs -f frontend

# ✅ データベース接続
docker compose exec db mysql -u myapp -p

# ✅ Backend（Rails）テスト
docker compose exec backend bash -lc "RAILS_ENV=test bundle exec rspec --format documentation"
```

## 🌐 サービス詳細

### ✅ **Frontend（React SPA）**
- **ポート**: 3001  
- **URL**: http://localhost:3001
- **技術**: React 18 + Create React App
- **開発サーバー**: Node.js 18 Alpine

### ✅ **データベース（MySQL）**
- **ポート**: 3306
- **データベース**: `myapp_development`
- **ユーザー**: `myapp` / `myapp_pass`  
- **ボリューム**: `db-data`（永続化）
- **接続**: `mysql -h localhost -P 3306 -u myapp -p`

### ✅ **ストレージ（MinIO）**
- **API**: http://localhost:9000
- **管理画面**: http://localhost:9003
- **認証**: `minioadmin` / `minioadmin`
- **バケット**: `myapp-bucket`
- **ボリューム**: `minio-data`（永続化）

### ✅ **Backend（Rails API）**
- **ポート**: 3000
- **疎通**: http://localhost:3000/health が 200 OK を返す
- **テスト**: RSpec（request spec）

### 🚧 **認証（AWS Cognito代替）** - 開発予定
- **予定ポート**: 5000
- **候補技術**: moto/Cognito または別認証システム

## 🐛 トラブルシューティング

### よくある問題と解決策

#### ポート競合エラー
```bash
Error: port is already allocated
```
**解決**: 使用中のポートを確認・停止
```bash
# Windows
netstat -ano | findstr :3001
taskkill /PID <PID> /F

# 完全クリーンアップ
docker compose down --volumes
docker system prune -a
```

#### コンテナビルド失敗
```bash
bundle install エラー / npm install エラー
```
**解決**: キャッシュクリア + 再ビルド
```bash
docker compose build --no-cache
docker compose up --build
```

#### データベース接続エラー
```bash
Access denied for user 'myapp'
```
**解決**: 環境変数とボリューム確認
```bash
# 設定ファイル確認
cat backend/.env.development
cat backend/config/database.yml

# DB再初期化
docker compose down --volumes
docker compose up db
```

## 📝 開発ガイドライン

### Git ワークフロー

```bash
# 機能ブランチ作成
git checkout -b feature/新機能名

# コミット（推奨形式）
git commit -m "feat: 新機能の説明

🚀 Features:
- 具体的な変更内容

✅ Tests:
- テストケース追加"

# プッシュ・プルリクエスト
git push origin feature/新機能名  
```

### コード規約

- **Rails**: RuboCop準拠
- **React**: ESLint + Prettier
- **コミット**: Conventional Commits
- **テスト**: RSpec（Backend）+ Vitest（Frontend）

## 🤝 コントリビューション

1. **Issues**: バグ報告・機能要望
2. **Pull Requests**: コード改善・新機能
3. **Discussions**: アイデア・質問・議論
4. **Star⭐**: プロジェクト応援

## 📄 ライセンス

このプロジェクトは **MIT License** の下で公開されています。

## 🔗 関連リンク

- **GitHub**: https://github.com/small-java-world/tsumiki-sample-project
- **Rails Guide**: https://guides.rubyonrails.org/
- **React Docs**: https://react.dev/
- **Docker Docs**: https://docs.docker.com/
- **Tsumiki**: AI駆動開発ツール
- **Git Worktree 開発ガイド**: docs/worktree-development.md — Worktree + DevContainer + Serena の詳細手順
- **Worktree 設計ポリシー**: docs/worktree-design.md — ディレクトリ構成とベアリポジトリ戦略

---

## 📈 開発ロードマップ

### Phase 1: 基盤構築 ✅ **完全完了**
- [x] Docker環境セットアップ
- [x] React フロントエンド構成
- [x] MySQL + MinIO ストレージ設定  
- [x] Tsumikiコマンド統合（21種類）
- [x] GitHub連携
- [x] AI開発ツール環境（Claude Code CLI）
- [x] **CI/CD パイプライン（GitHub Actions）**
- [x] **Dependabot自動更新・自動マージ**
- [x] **Git Worktree 並行開発環境**
- [x] **Issue・PRテンプレート**
- [x] **本番環境デプロイ設定**
- [x] **セキュリティスキャン（Trivy）**

### Phase 2: Backend開発 🚧
- [ ] Rails API 完全構成
- [ ] REST APIエンドポイント設計
- [ ] データベースマイグレーション
- [ ] ユーザー認証システム
- [ ] API ドキュメント作成

### Phase 3: 機能拡張 📋
- [ ] フロントエンド画面実装
- [ ] ファイルアップロード機能
- [ ] テストカバレッジ向上（RSpec）
- [x] CI/CD パイプライン（GitHub Actions）
- [ ] パフォーマンス最適化
- [x] Dependabot自動依存関係更新

---

---

## 🎯 **プロジェクト完成度**

### ✅ **100% 完了機能**
- **開発環境**: Docker Compose完全構成
- **CI/CD**: エンタープライズレベル自動化
- **AI開発**: Tsumiki + Claude Code CLI統合
- **品質管理**: 自動テスト・セキュリティスキャン
- **並行開発**: Git Worktree環境
- **本番対応**: デプロイ・監視・セキュリティ

### 🚧 **開発予定機能**  
- Rails API完全実装
- 認証システム構築
- フロントエンド画面開発

---

**🎉 Happy Coding with Tsumiki AI Development! 🤖✨**

*このプロジェクトは**エンタープライズレベル**の開発環境を提供し、AI支援による高効率開発を実現します。*
