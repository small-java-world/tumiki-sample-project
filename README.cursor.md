# Cursor CLI で Tsumiki を使う（リポジトリ全体）

本リポジトリの Tsumiki コマンド（`/tdd-*`, `/kairo-*` など）を Cursor CLI から実行する方法です。

参考: [Cursor CLI](https://cursor.com/ja/cli)

## 1. インストール

```bash
curl https://cursor.com/install -fsS | bash
```

## 2. ルール定義（AGENTS.md）

リポジトリ直下に `AGENTS.md` を作成して、Tsumiki 用エージェントとコマンド名を定義します（例）。

```markdown
## agent: tsumiki

rules:
- Rails + React のTDDを前提。Red→Green→Refactor を徹底
- 変更は最小。差分提示と実行ログを常に返す

commands:
- name: /tdd-red
  description: 失敗テストの生成
- name: /tdd-green
  description: 直前の Red を通す最小実装
- name: /tdd-refactor
  description: 重複排除・命名改善
- name: /kairo-requirements
  description: 要件分解
```

詳細なプロンプトは `.claude/commands/` を参照（そのまま引用/要約して使えます）。

## 3. 実行例

```text
/tdd-red フロントのトップに「Check API Health」ボタンのUTを追加し、Redを確認
```

## 4. よく使うコマンド

- サービス起動
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

---

Copyright © 2025


