# Cursor CLI で Tsumiki を使う（rails-react-tdd-sample-app）

このドキュメントは、Cursor CLI を使って本リポジトリの Tsumiki スラッシュコマンド（/tdd-*, /kairo-* など）を実行し、TDD を進める手順の最小セットです。

参考: [Cursor CLI](https://cursor.com/ja/cli)

## 1. インストール

```bash
curl https://cursor.com/install -fsS | bash
```

インストール後、ターミナルで `cursor` コマンドが使えることを確認してください。

## 2. ルール/コマンド定義（AGENTS.md）

リポジトリ直下に `AGENTS.md` を作成し、Tsumiki のスラッシュコマンドを定義します（例）。

```markdown
## agent: tsumiki

rules:
- 本リポジトリは Rails + React のTDDサンプル。/tdd-* を優先して実行
- 変更は最小限、失敗したら理由をログで返す

commands:
- name: /tdd-red
  description: 失敗するテストを追加して Red を作る
- name: /tdd-green
  description: 直前の Red を最小変更で通す
- name: /tdd-refactor
  description: 重複排除・命名改善・構成整理
- name: /kairo-requirements
  description: 画面/機能の要件ブレイクダウン
```

すでに `.claude/commands/` に詳細なプロンプトが揃っているため、`AGENTS.md` では短い説明だけ用意し、実際の作業は各 `/tdd-*` 実行時に補足すると運用しやすいです。

## 3. 使い方

1) リポジトリ直下で Cursor CLI を起動（任意のターミナル）
2) `/tdd-red` などスラッシュコマンドを入力し、指示を続けます

例:

```
/tdd-red サービス詳細の初期表示を検証するテストを追加し、実行して Red を確認
```

## 4. サービス起動/テスト

- 全サービス起動
```bash
docker compose up -d --build
```

- Backend UT（RSpec）
```bash
docker compose exec backend bash -lc "RAILS_ENV=test bundle exec rspec --format documentation"
```

- Frontend UT（Vitest）
```bash
docker compose exec frontend sh -lc "npm test -- --run"
```

## 5. よくある運用

- Red → Green → Refactor の 1 サイクルごとにコミット
- 破壊的変更は必ずテスト追加後に実施
- 依存更新や CI 化は別ブランチで実施

---

Copyright © 2025


