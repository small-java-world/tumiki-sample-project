# Work Plan — User Preferences (feature/user-preferences)

時系列の実行手順（Tsumikiのタスク分割を前提）。

- 0. 準備（ブランチ/起動確認）
  ```bash
  # アプリ側リポジトリのブランチ（GitHub上）
  # small-java-world/rails-react-tdd-sample-app の feature/user-preferences を使用
  docker compose up -d --build
  docker compose ps
  ```

- 1. タスク分割（/kairo-tasks）
  ```text
  /kairo-tasks User Preferences を3〜5タスクへ分割
  # 例: テーマ切替 / 自動更新間隔 / 表示密度 / 永続化(localStorage) / リセット
  ```

- 2. Red一覧（/tdd-testcases）
  ```text
  /tdd-testcases User Preferences のRed一覧を作成
  # 観点: UI切替の即時反映 / 永続化の保存/読込 / リセットの既定値復元
  ```

- 3. スライス1: 設定UIと即時反映
  - 失敗テストを追加 → 最小実装 → リファクタ
  ```text
  /tdd-red スライス1（設定UI＋即時反映）の失敗テストを生成
  /tdd-green スライス1を最小変更でGreen化
  /tdd-refactor 命名/重複/構成を整理
  ```
  - テスト実行
  ```bash
  docker compose exec frontend sh -lc "npm test -- --run"
  ```

- 4. スライス2: 永続化（localStorage）
  ```text
  /tdd-red スライス2（保存/読込）の失敗テストを生成
  /tdd-green スライス2を最小変更でGreen化
  /tdd-refactor スライス2の整理
  ```
  ```bash
  docker compose exec frontend sh -lc "npm test -- --run"
  ```

- 5. スライス3: リセット（デフォルトへ戻す）
  ```text
  /tdd-red スライス3（リセット）の失敗テストを生成
  /tdd-green スライス3を最小変更でGreen化
  /tdd-refactor スライス3の整理
  ```
  ```bash
  docker compose exec frontend sh -lc "npm test -- --run"
  ```

- 6. ドキュメント/PRD更新
  ```bash
  # 変更差分を反映（このリポジトリ側のPRDを同期）
  git add -A
  git commit -m "docs(user-preferences): update PRD and notes"
  git push origin main
  ```

- 7. RSpec/統合確認（必要に応じて）
  ```bash
  docker compose exec backend bash -lc "RAILS_ENV=test bundle exec rspec --format documentation"
  curl -i http://localhost:3000/health | sed -n '1,20p'
  ```

- 8. 仕上げ（PR作成：アプリ側リポジトリで）
  ```bash
  gh pr create --fill --head feature/user-preferences || true
  # GitHub UIでも可
  ```
