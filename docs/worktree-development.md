# 🌳 Git Worktree 開発ガイド

> **対象読者**: 本プロジェクトで *Git worktree* を利用して並行開発を行う開発者

---

## 📖 目次
1. [概要](#概要)
2. [前提条件](#前提条件)
3. [Tsumiki / Claude Code 設定](#tsumiki--claude-code-設定)
4. [Serena MCP サーバー設定](#serena-mcp-サーバー設定)
5. [初期セットアップ](#初期セットアップ)
6. [日常的な開発フロー](#日常的な開発フロー)
7. [2 つのフィーチャーブランチで Tsumiki 開発を行う例](#2-つのフィーチャーブランチで-tsumiki-開発を行う例)
8. [Claude Code に Worktree のファイルを認識させる方法](#claude-code-に-worktree-のファイルを認識させる方法)
9. [Claude Code とコンテナ名の橋渡し](#claude-code-とコンテナ名の橋渡し)
10. [代表的なコマンド集](#代表的なコマンド集)
11. [スクリプト活用（推奨）](#スクリプト活用推奨)
12. [トラブルシューティング](#トラブルシューティング)
13. [FAQ](#faq)

---

## 概要

> ⚙️ **本ドキュメントは VS Code Dev Container を常駐させつつ、Claude Code CLI / Tsumiki は *ホスト OS* から実行するハイブリッド開発を前提としています。**
>
> - VS Code は `Reopen in Container` で devcontainer 内に入り、アプリ（Rails / React など）はコンテナ内で動作。
> - ホスト側には Node.js と `@anthropic-ai/claude-code` だけをインストールし、`claude -p ...` を実行。
> - テストやビルドは `docker compose exec <service>` を Tsumiki から呼び出し **Worktree ごとのコンテナ** で並列実行。
> - Worktree ディレクトリごとに `.env` の `COMPOSE_PROJECT_NAME` を変えてコンテナ名を衝突させない。


Git worktree は、**1 つのリポジトリから複数のチェックアウト先**を作成できる Git の公式機能です。これにより次のようなメリットがあります。

| 🎯 シナリオ | 従来の方法 (ブランチ切替) | Git worktree |
|-------------|---------------------------|--------------|
| 複数機能・バグを**同時**に開発 | `git checkout` を繰り返す | **別フォルダ**で並行作業 |
| ビルド / テストの**並列実行** | 1 つずつ | ★ 可能 |
| **PR レビュー**と開発を同時に進行 | 困難 | ★ 可能 |

---

## 前提条件

| ツール | バージョン | 確認コマンド |
|--------|------------|--------------|
| Git    | 2.15 以上 | `git --version` |
| Node.js / npm | 18.x 系 | `node -v` / `npm -v` |
| PowerShell (Windows) | 5+ / 7+ | `pwsh -v` |
| Bash (Linux/Mac) | 任意 | `bash --version` |

> **Tip**: Git 2.30 以降推奨。`git worktree` コマンドの機能が拡充されています。

---

## Tsumiki / Claude Code 設定

Tsumiki を使用するために、まず **Claude Code CLI** をホスト OS にインストールし、Tsumiki 用のディレクトリ構成と設定を行う。

| 手順 | コマンド | 備考 |
|------|----------|------|
| 1. CLI インストール | `npm install -g @anthropic-ai/claude-code` | Node 18+ 必須 |
| 2. API キー登録 | `claude login` | `ANTHROPIC_API_KEY` を入力 |
| 3. Tsumiki コマンド一式導入 | `npx tsumiki install` | `.claude/commands/` が生成 |
| 4. allowedTools テンプレ修正 | `.claude/commands/tdd-red.md` など `execution:` を編集し<br/>`Bash(cx *)` を許可 | Worktree ラッパー関数 `cx` を利用 |

> **Tips**
> - API キーは macOS/Linux は `~/.config/claude/`、Windows は `%APPDATA%\claude\` に保存されます。
> - テンプレ編集は一括置換すると楽です (`allowedTools: "Write,Edit,Bash(cx *)"`).
> - `npx tsumiki install` は Worktree ディレクトリすべてに一度ずつ実行すると、`.claude/commands` が各ブランチに配置され自動マージで競合しません。

---

## Serena MCP サーバー設定

Serena は LSP を利用した MCP (Model Context Protocol) サーバーです。Tsumiki と組み合わせることで、コード検索・編集を IDE レベルの精度で自動化できます。

### 1. インストール (uv 経由)
```bash
# uv が未インストールなら
curl -LsSf https://astral.sh/uv/install.sh | sh

# Serena を起動 (初回はインデックス生成に数十秒かかる)
uvx --from git+https://github.com/oraios/serena \
  serena start-mcp-server --context ide-assistant --project $(pwd)
```

### 2. Claude Code への登録
```bash
claude mcp add serena -s project \
  -- uvx --from git+https://github.com/oraios/serena \
  serena start-mcp-server --context ide-assistant --project $(pwd)
```
`.mcp.json` が作成され、Worktree ルートで `claude -p` を実行すると Serena が自動起動します。

### 3. allowedTools の追加例
既存の Tsumiki テンプレートに次を追記してください。

```yaml
execution:
  allowedTools: "Write,Edit,Bash(cx *),MCP(serena:*)"
```

### 4. Worktree 運用 Tips
- **各 Worktree で一度だけ** `claude mcp add serena` を実行する。
- 大規模変更後は MCP サーバーを再起動して LSP インデックスを更新。

### Serena 単独で効果が高い作業 7 選

| # | タスク内容 | 利用ツール例 |
|---|------------|--------------|
| 1 | 大量シンボルの Rename／移動 | `find_symbol` + `replace_regex` |
| 2 | インターフェース実装漏れ・重複実装検出 | `find_symbol(interface: ...)` + 参照一覧 |
| 3 | 重複コード抽出 (DRY 化) | `search_for_pattern` + `replace_regex` |
| 4 | 型エラーの前掃除 (TS/Rust 等) | `get_symbols_overview(unused_imports)` + `replace_regex` |
| 5 | ドメインマッピング自動生成 | `find_symbol(class: *Entity)` + Markdown 出力 |
| 6 | 静的解析指摘の一括修正 | `search_for_pattern` + `replace_regex` |
| 7 | バージョン定数などの一括更新 | リテラル検索 + `replace_regex` |

> **ポイント**  
> - 上記はテスト実行やコンテナ操作が不要なため Serena 単体で完結し、トークン・時間を大幅節約。  
> - 外部副作用がないため安全にリファクタリングを進められる。

---

## 初期セットアップ

### 1. ベアリポジトリを作成
```bash
cd ..
git clone --bare <REMOTE_URL> myapp-bare
```

### 2. Worktree を追加
```bash
cd myapp-bare
# メインブランチ
git worktree add ../main main
# 開発ブランチ
git worktree add -b develop ../develop
```

### 3. 追加の Worktree
```bash
# 機能開発
git worktree add -b feature/user-auth ../feature-user-auth
# 緊急修正
git worktree add -b hotfix/critical-bug ../hotfix-critical-bug
```

> **構造イメージ**
> ```text
> repo-root/
> ├── myapp-bare/      (bare)
> ├── main/            (main)
> ├── develop/         (develop)
> ├── feature-user-auth/
> └── hotfix-critical-bug/
> ```

---

## 日常的な開発フロー

| フェーズ | コマンド例 |
|----------|-----------|
| 新機能開始 | `git worktree add -b feature/payment ../feature-payment` |
| コーディング | 任意のエディタで編集 |
| コミット | `git add . && git commit -m "feat: payment UI"` |
| プッシュ | `git push -u origin feature/payment` |
| PR 作成 | GitHub 上で PR を作成 |
| worktree 状態確認 | `git worktree list` |
| 同期 (全 worktree) | `git fetch --all --prune` + 各 worktree で `git pull` |
| 削除 (終了したブランチ) | `git worktree remove ../feature-payment` → `git branch -d feature/payment` |

---

## 2 つのフィーチャーブランチで Tsumiki 開発を行う例

以下では、`feature/user-auth` と `feature/payment` の 2 本を同時に進めつつ、各ブランチで **Tsumiki (Claude Code CLI)** を用いた AI 駆動開発を実施する流れを示します。

### 0. 前準備 (Dev Container + Claude CLI)

| 手順 | コマンド | 実行場所 |
|------|----------|----------|
| Dev Container 起動 | VS Code `Remote-Containers: Reopen in Container`<br/>（Compose devcontainer ならサービスも自動起動） | VS Code |
| （Dockerfile 型 devcontainer のみ）アプリ用サービス起動 | `docker compose up -d` | **ホスト** |
| Claude CLI インストール | `npm install -g @anthropic-ai/claude-code` | **ホスト** |
| Claude ログイン | `claude login` | **ホスト** |

> - **Compose devcontainer** (`.devcontainer/docker-compose.yml` がある構成) では、VS Code が `docker compose up` を自動で実行するため **手動起動は不要** です。
> - **Dockerfile 型 devcontainer** の場合は、開発用サービス（db, minio など）をホスト側で `docker compose up -d` して常駐させてください。
> - 以降、`claude -p ...` はすべて **ホスト側** で実行し、Tsumiki が `docker compose exec` 経由で該当サービスにテストやビルドを投げ込みます。

### 1. ブランチ & Worktree 作成
```bash
# User Auth 機能
git worktree add -b feature/user-auth ../feature-user-auth

# Payment 機能
git worktree add -b feature/payment ../feature-payment
```

### 2. Tsumiki で要件定義 (各 Worktree)
```bash
# User Auth
cd ../feature-user-auth
claude -p "/kairo-requirements ユーザー認証"

# Payment
cd ../feature-payment
claude -p "/kairo-requirements 決済機能"
```

### 3. TDD サイクル (Red → Green → Refactor)
```bash
# User Auth (例)
claude -p "/tdd-red ログイン成功"
claude -p "/tdd-green ログイン成功"
claude -p "/tdd-refactor ログイン成功"

# Payment (例)
claude -p "/tdd-red クレジット決済"
claude -p "/tdd-green クレジット決済"
claude -p "/tdd-refactor クレジット決済"
```

### 4. プッシュ & PR 作成
```bash
cd ../feature-user-auth
git add . && git commit -m "feat: add user auth" && git push -u origin feature/user-auth

cd ../feature-payment
git add . && git commit -m "feat: add payment" && git push -u origin feature/payment
```

それぞれ GitHub 上で PR を作成し、レビューが通ったら `develop` へマージします。

---

### ⏱️ 時系列コマンド一覧（Dev Container + ホスト）

| 🕒 時刻 | アクション / コマンド | 実行場所 |
|---------|-----------------------|-----------|
| 00:00 | `git worktree add -b feature/user-auth ../feature-user-auth` | ホスト |
| 00:01 | `cp -p ../env.template ../feature-user-auth/.env` → `COMPOSE_PROJECT_NAME=myapp_user-auth` に書き換え | ホスト |
| 00:02 | `code ../feature-user-auth` → VS Code が **その worktree** を開く | ホスト |
| 00:03 | VS Code 内で `Reopen in Container`（Compose devcontainer が自動起動） | VS Code UI |
| 00:04 | `git worktree add -b feature/payment ../feature-payment` | ホスト |
| 00:05 | `cp -p ../env.template ../feature-payment/.env` → `COMPOSE_PROJECT_NAME=myapp_payment` に書き換え | ホスト |
| 00:06 | `code ../feature-payment` → VS Code が **その worktree** を開く | ホスト |
| 00:07 | VS Code 内で `Reopen in Container` | VS Code UI |
| 00:08 | `cd ../feature-user-auth` | ホスト |
| 00:09 | `claude -p "/kairo-requirements ユーザー認証" --allowedTools "Write,Edit,Bash(cx *)"` | ホスト (Claude CLI) |
| 00:10 | `claude -p "/tdd-red ログイン成功" --allowedTools "Write,Edit,Bash(cx *)"` | ホスト |
| 00:11 | Tsumiki が `cx bundle exec rspec` → `docker compose exec backend bundle exec rspec` | Dev Container コンテナ |
| 00:15 | `git add . && git commit -m "feat: user auth"` | ホスト |
| 00:16 | `git push -u origin feature/user-auth` | ホスト |
| 00:18 | `cd ../feature-payment` | ホスト |
| 00:19 | `claude -p "/kairo-requirements 決済機能" --allowedTools "Write,Edit,Bash(cx *)"` | ホスト |
| 00:22 | `claude -p "/tdd-red クレジット決済" --allowedTools "Write,Edit,Bash(cx *)"` | ホスト |
| 00:25 | Tsumiki が `cx npm test` → `docker compose exec frontend npm test` | Dev Container コンテナ |
| 00:30 | `git add . && git commit -m "feat: payment"` | ホスト |
| 00:31 | `git push -u origin feature/payment` | ホスト |
| 00:35 | GitHub で 2 本の PR 作成 → CI/CD 実行 | ブラウザ |
| 00:40 | PR を `develop` へマージ (Squash or Rebase) | ブラウザ |
| 00:42 | `cd ../develop` && `git pull` | ホスト |
| 00:43 | `git worktree remove ../feature-user-auth` | ホスト |
| 00:44 | `git branch -d feature/user-auth` | ホスト |
| 00:45 | `git worktree remove ../feature-payment` | ホスト |
| 00:46 | `git branch -d feature/payment` | ホスト |

---

## Claude Code に Worktree のファイルを認識させる方法

Claude Code CLI は「実行時のカレントディレクトリ直下 〜 2 レベル程度のファイル」を自動でスキャンしてコンテキストを生成します。そのため **必ず worktree ルートで `claude -p` を実行** すれば、該当ブランチだけのファイルが AI に渡ります。

### ✅ 基本ルール
1. `cd ../feature-user-auth` など **worktree ルートで実行** する。  
2. `.claude/commands/` をその worktree に **コミットしておく**（`npx tsumiki install` を各 worktree で一度実行）。  
3. 巨大リポジトリで 2 階層より深いファイルを参照させたい場合は `-C` オプションで明示する。

```bash
# 例: worktree ルートより 3 階層下の src/ までコンテキストに含める
claude -C src -p "/rev-design 支払いドメイン"
```

> **注意**  
> - `claude -C` は *追加* ではなく “そのディレクトリのみ” を対象にするため、多数のディレクトリを一括で渡す場合はシェルスクリプトで連続実行するか、`contextPaths` を使った `claude.yml` を用意します。

### 🔧 高度な設定例：claude.yml
`worktree-root/claude.yml` を置くと、毎回 `-C` を書かずに済みます。
```yaml
autoContext:
  include:
    - "src/**"
    - "config/**"
  exclude:
    - "node_modules/**"
    - "tmp/**"
```

CLI はこれを読んで自動でファイルを選定します。

---

## Claude Code とコンテナ名の橋渡し

Worktree ごとに `COMPOSE_PROJECT_NAME` を変えた場合、ホストで実行する `claude -p` には *どのコンテナにコマンドを投げるか* を明示する必要があります。推奨構成は次の 3 ステップです。

| 手順 | 具体例 | 備考 |
|------|--------|------|
| 1. Worktree 直下に `.env` を置く（`cp ../env.template .env` して編集） | `COMPOSE_PROJECT_NAME=myapp_user-auth` | `docker compose` が自動で読み取る |
| 2. ホスト shell 関数 / スクリプト `cx` を用意 | `cx() { docker compose exec backend "$@"; }` | PowerShell なら `function cx { param($cmd) docker compose exec backend $cmd }` |
| 3. Tsumiki の *allowedTools* に `Bash(cx *)` を登録 | `--allowedTools "Write,Edit,Bash(cx *)"` | コンテナ名を直接書かずに済む |

これにより、Worktree 内で
```bash
claude -p "/tdd-red (user-auth) ログイン成功" --allowedTools "Write,Edit,Bash(cx *)"
```
と実行すると、Tsumiki がテスト実行時に
```bash
docker compose exec backend bundle exec rspec
```
を発行し、現在の Worktree の `COMPOSE_PROJECT_NAME` が反映された `myapp_user-auth-backend-1` コンテナでテストが走ります。

> **補足**  
> **設定例**  
> `.claude/commands/tdd-red.md` の `execution:` セクションを開き、次のように編集します。
> ```yaml
> execution:
>   allowedTools: "Write,Edit,Bash(cx *)"
>   disallowedTools: "Bash(rm *),Bash(git *)"
> ```  
> これで **Tsumiki が `cx` 経由でコンテナ上でコマンドを実行できる** ようになります。
>
> - `cx` という “コンテナ実行ラッパー” を挟むことで、Prompt にコンテナ名を書かずに済むため Worktree を切り替えても同じ Prompt が再利用できます。  
> - `Bash(docker compose exec backend *)` を直接許可しても良いのですが、`cx` の方が安全で短いコマンドになります。

---

## 代表的なコマンド集

| 用途 | Bash | PowerShell |
|------|------|-----------|
| Worktree 一覧 | `git worktree list` | 同左 |
| 機能 Worktree 作成 | `git worktree add -b feature/xxx ../feature-xxx` | `.\scripts\worktree-helper.ps1 feature xxx` |
| ホットフィックス作成 | `git worktree add -b hotfix/yyy ../hotfix-yyy main` | `.\scripts\worktree-helper.ps1 hotfix yyy` |
| Worktree 削除 | `git worktree remove ../feature-xxx` | 同左 |
| 不要参照掃除 | `git worktree prune` | 同左 |

---

## スクリプト活用（推奨）

プロジェクトルートの `scripts/` に Worktree 専用スクリプトを配置済みです。

| OS | セットアップ | 管理ヘルパー |
|----|-------------|--------------|
| Windows | `scripts\setup-worktree.ps1` | `scripts\worktree-helper.ps1` |
| Linux/Mac | `scripts/setup-worktree.sh` | `scripts/worktree-helper.sh` |

> スクリプトが使えない場合も、前述の *手動コマンド* で同様にセットアップできます。

---

## トラブルシューティング

| 症状 | 原因 / 解決策 |
|------|--------------|
| `fatal: not a git repository` | ベアリポジトリ or Worktree のパスを誤っている → パスを確認 |
| Worktree のブランチが Push できない | `git push -u origin <branch>` でトラッキング設定 |
| Worktree 削除できない | 対象ディレクトリでプロセスが開いていないか確認 & `git worktree remove --force` |

---

## FAQ

**Q. Worktree 内でブランチを切り替えられる？**  
A. Worktree ディレクトリは個別 HEAD を持つため `git checkout` を使用せず、*別の Worktree を作成*してください。

**Q. Disk 使用量は増えない？**  
A. オブジェクトはベアリポジトリに共有されるため、大部分は共用されます。ファイル差分のみが増加します。

**Q. CI/CD に影響は？**  
A. GitHub Actions では `fetch-depth: 0` を指定し、Worktree でも完全履歴を取得するワークフローを設定済みです。

---

> **Happy Parallel Coding with Git Worktree!**
