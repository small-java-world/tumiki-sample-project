# Tumiki Sample Project 🚀

Rails + React + MySQL + MinIO + moto（Cognito代替）を使用したフルスタック開発環境

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![Rails](https://img.shields.io/badge/Rails-7.0-red.svg)](https://rubyonrails.org)
[![React](https://img.shields.io/badge/React-18-blue.svg)](https://reactjs.org)
[![Tsumiki](https://img.shields.io/badge/Tsumiki-AI%20Driven-green.svg)](https://github.com/small-java-world/tumiki-sample-project)

## 📋 プロジェクト概要

このプロジェクトは、**Tsumiki AI開発ツール**を活用したモダンなフルスタックWebアプリケーションのテンプレートです。Docker Composeを使用して、開発に必要なすべてのサービスをローカル環境で簡単に起動できます。

### 🎯 特徴

- **🤖 AI駆動開発**: 21種類のTsumikiコマンドでAI支援開発
- **📦 コンテナ化**: Docker Composeで統一された開発環境
- **🌐 フルスタック**: Rails API + React SPA構成
- **🗄️ 完全DB**: MySQL + MinIO S3互換ストレージ
- **🔐 認証対応**: moto（Cognito代替）
- **📝 日本語対応**: 包括的な日本語ドキュメント

## 🛠️ 技術スタック

### Backend
- **Ruby 3.2.9** + **Rails 7.0**
- **MySQL 8.0** - メインデータベース
- **MinIO** - S3互換オブジェクトストレージ
- **moto** - AWS Cognito代替（認証）
- **RSpec** + **FactoryBot** - テスト環境

### Frontend  
- **React 18** + **Node.js 18**
- **Create React App** - 開発環境
- **Proxy設定** - Rails APIとの連携

### Infrastructure
- **Docker** + **Docker Compose**
- **Debian Bullseye** - コンテナベースOS

### AI Development Tools
- **Tsumiki** - AI駆動開発コマンド集
- **Claude Dev** - VS Code拡張機能対応

## 🚀 クイックスタート

### 前提条件

- **Docker** & **Docker Compose** インストール済み
- **Git** インストール済み  
- **VS Code** (推奨)

### 1. リポジトリクローン

```bash
git clone https://github.com/small-java-world/tumiki-sample-project.git
cd tumiki-sample-project
```

### 2. 開発環境起動

```bash
# 全サービス起動
docker compose up --build

# バックグラウンド起動
docker compose up -d --build
```

### 3. サービス確認

| サービス | URL | 説明 |
|---------|-----|------|
| **React Frontend** | http://localhost:3001 | Webアプリケーション |
| **Rails Backend** | http://localhost:3000 | REST API |
| **MinIO Console** | http://localhost:9003 | ストレージ管理画面 |
| **MySQL** | localhost:3306 | データベース接続 |

## 📁 ディレクトリ構成

```
tumiki-sample-project/
├── .claude/commands/          # Tsumiki AIコマンド集（21個）
│   ├── kairo-*.md            # 要件→実装フロー
│   ├── tdd-*.md              # テスト駆動開発
│   └── rev-*.md              # レビュー系コマンド
├── backend/                   # Rails API
│   ├── Dockerfile            # Rails用Dockerファイル
│   ├── Gemfile               # Ruby依存関係
│   ├── config/               # Rails設定
│   │   ├── database.yml      # DB接続設定
│   │   ├── storage.yml       # MinIO設定
│   │   └── initializers/     # 初期化処理
│   ├── bin/rails             # Rails実行ファイル
│   └── spec/                 # RSpecテスト
├── frontend/                  # React SPA
│   ├── package.json          # Node.js依存関係
│   ├── src/                  # Reactソースコード
│   └── public/               # 静的ファイル
├── docker-compose.yml         # サービス定義
├── .gitignore                # Git除外設定（最適化済み）
└── README.md                 # このファイル
```

## 🤖 Tsumiki AI コマンド活用

### 主要コマンド

```bash
# 要件定義→設計→実装フロー
.claude/commands/kairo-requirements.md    # 要件整理
.claude/commands/kairo-design.md          # 設計作成
.claude/commands/kairo-implement.md       # 実装支援

# テスト駆動開発
.claude/commands/tdd-requirements.md      # テスト要件
.claude/commands/tdd-red.md               # Red（失敗テスト）
.claude/commands/tdd-green.md             # Green（実装）
.claude/commands/tdd-refactor.md          # Refactor（リファクタ）

# レビュー・検証
.claude/commands/rev-requirements.md      # 要件レビュー
.claude/commands/rev-design.md            # 設計レビュー
.claude/commands/rev-specs.md             # 仕様書レビュー
```

### VS Code + Claude Dev 連携

1. **Claude Dev拡張機能** インストール済み
2. **コマンドパレット**: `Ctrl+Shift+P` → `Claude Dev: Start Chat`
3. **Tsumikiコマンド**: `.claude/commands/` 内のMarkdownファイルを参照
4. **AI支援開発**: ファイル編集・デバッグ・コード生成

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
# Backend（Rails）テスト
docker compose exec backend bundle exec rspec

# Frontend（React）開発サーバー
docker compose exec frontend npm start

# データベース接続
docker compose exec db mysql -u myapp -p
```

## 🌐 サービス詳細

### 🔴 Backend（Rails API）
- **ポート**: 3000
- **環境変数**: `backend/.env.development`
- **データベース**: MySQL（`myapp_development`）
- **ストレージ**: MinIO S3互換
- **認証**: moto/Cognito

### 🔵 Frontend（React SPA）
- **ポート**: 3001  
- **プロキシ**: Rails API（localhost:3000）
- **環境変数**: `frontend/.env.development`
- **ビルドツール**: Create React App

### 🗄️ データベース（MySQL）
- **ポート**: 3306
- **データベース**: `myapp_development`
- **ユーザー**: `myapp` / `myapp_pass`
- **ボリューム**: `db-data`（永続化）

### 📦 ストレージ（MinIO）
- **API**: http://localhost:9000
- **管理画面**: http://localhost:9003
- **認証**: `minioadmin` / `minioadmin`
- **バケット**: `myapp-bucket`
- **ボリューム**: `minio-data`（永続化）

### 🔐 認証（moto/Cognito）
- **ポート**: 5000
- **用途**: AWS Cognito API代替
- **設定**: `backend/config/initializers/cognito.rb`

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
- **テスト**: RSpec（Backend）+ Jest（Frontend）

## 🤝 コントリビューション

1. **Issues**: バグ報告・機能要望
2. **Pull Requests**: コード改善・新機能
3. **Discussions**: アイデア・質問・議論
4. **Star⭐**: プロジェクト応援

## 📄 ライセンス

このプロジェクトは **MIT License** の下で公開されています。

## 🔗 関連リンク

- **GitHub**: https://github.com/small-java-world/tumiki-sample-project
- **Rails Guide**: https://guides.rubyonrails.org/
- **React Docs**: https://react.dev/
- **Docker Docs**: https://docs.docker.com/
- **Tsumiki**: AI駆動開発ツール

---

## 📈 開発ロードマップ

### Phase 1: 基盤構築 ✅
- [x] Docker環境セットアップ
- [x] Rails + React基本構成  
- [x] データベース・ストレージ設定
- [x] Tsumikiコマンド統合
- [x] GitHub連携

### Phase 2: 機能開発 🚧
- [ ] ユーザー認証システム
- [ ] ファイルアップロード機能
- [ ] RESTful API設計
- [ ] フロントエンド画面実装

### Phase 3: 拡張・最適化 📋
- [ ] テストカバレッジ向上
- [ ] CI/CD パイプライン
- [ ] パフォーマンス最適化
- [ ] セキュリティ強化

---

**🎉 Happy Coding with Tsumiki AI Development! 🤖✨**