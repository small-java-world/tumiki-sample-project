# 🌳 Git Worktree 開発設計書

## 1. 目的

Git Worktree を活用して **"1 プロジェクト = 1 ベアリポジトリ"** 方式に統一し、次の開発要求を満たす。

1. **並列開発速度の最大化** – 機能追加・バグ修正・リリース作業をディレクトリ単位で並行実行
2. **CI/CD & GitHub Flow 互換** – PR ベースのレビューと GitHub Actions をそのまま利用
3. **ローカル体験の向上** – `docker compose` を Worktree 毎に立ち上げテストを並列化
4. **学習コスト最小化** – 既存 Git コマンドと最小限のスクリプトだけで運用

---

## 2. 全体構成

```text
repo-root/
├── myapp-bare/            # (bare) 共有オブジェクトを持つベアリポジトリ
│
├── main/                  # main ブランチ (production)
├── develop/               # develop ブランチ (integration)
│
├── feature-*/             # 機能開発用 worktree
├── hotfix-*/              # 緊急修正 worktree
└── release-*/             # リリース準備 worktree
```

- **ベアリポジトリ**: オブジェクトを一元管理し Git データ重複を防止
- **Worktree ディレクトリ**: ブランチ HEAD を個別保持。Docker ボリュームはブランチ単位に分離可

---

## 3. ブランチ・フロー

| 種別 | 命名規則 | 作成タイミング | マージ先 |
|------|----------|---------------|----------|
| Main | `main` | リリース後 | - |
| Develop | `develop` | 常時 | main |
| Feature | `feature/<name>` | 要件定義完了後 | develop |
| Hotfix | `hotfix/<name>` | 本番障害発生時 | main + develop |
| Release | `release/<version>` | リリース準備開始時 | main |

### フロー概要
1. **feature/** → develop へ PR & squash merge
2. **release/** branch を切り staging 検証 → main へ merge & タグ付与
3. **hotfix/** は main へ直 merge 後 develop へ cherry-pick

---

## 4. 開発環境起動（Worktree毎）

```bash
# 例: feature/login worktree
cd ../feature-login
cp ../env.template .env      # 各 worktree に個別 .env を配置可能
npm ci                       # Frontend 用
bundle install               # Backend 用 (将来)

docker compose up -d         # Worktree 専用コンテナ群起動
```

> **Port 衝突対策**: `.env` で `PORT_OFFSET` 変数を定義し `docker-compose.yml` のポートへ加算。

---

## 5. CI/CD 連携

| 項目 | 対応策 |
|------|--------|
| Worktree 検出 | `fetch-depth: 0` を `actions/checkout@v4` に設定し完全履歴取得 |
| Docker Job | 他 Worktree とのコンテナポート衝突を避けるためランダムポート割当 |
| Trivy Scan | PR ごとに `--exit-code 1 --severity MEDIUM,HIGH,CRITICAL` を実行 |
| Coverage   | Codecov でブランチ名 (feature/*) ごとにタグ付与 |

---

## 6. スクリプト仕様

### 6.1 setup-worktree.*
| 引数 | 内容 |
|------|------|
| –Help | ヘルプ表示のみ |
| –Force | 既存 Worktree 構成を上書き |

- **処理**: ベアリポジトリ作成 → main / develop Worktree 生成 → sample feature Worktree 生成

### 6.2 worktree-helper.*

| コマンド | 機能 |
|----------|------|
| `feature <name>` | 新規 feature Worktree 作成 |
| `hotfix <name>` | ホットフィックス Worktree 作成 (main 基点) |
| `list` | Worktree 一覧表示 |
| `status` | 変更・ahead/behind 状況レポート |
| `sync` | 全 Worktree をリモート同期 |
| `clean` | 不要 Worktree を prune |

---

## 7. リスクと対策

| リスク | 影響 | 対策 |
|--------|------|------|
| Worktree 乱立 | ディレクトリ散乱・混乱 | PR マージ後すぐ `git worktree remove` & `prune` を自動化 (helper) |
| コンテナポート衝突 | ローカル開発失敗 | `.env` で `PORT_OFFSET` を採用しスクリプトで自動計算 |
| ディスク容量増 | CI ランナー課金増 | CI では worktree を使わず通常 clone を採用 |

---

## 8. まとめ

Git Worktree により **並行開発・リリース効率**が大幅に向上します。本設計書をベースに開発フローを統一し、スクリプトと CI/CD を活用して運用コストを最小化してください。

> **Happy Parallel Coding!** 🎉
