# Test Plan — rails-react-tdd-sample-app

## 1. 方針
- TDD: Red → Green → Refactor
- 変更は最小、観点は明確化、テスト名は仕様を語る

## 2. Backend（RSpec）
- /health request spec
  - 200 OK, keys: status/components/metrics/time/commit
  - 依存が失敗した場合は status=degraded になる
- /auth/sign_in request spec（スタブ）
  - 200: 正常入力
  - 400: バリデーション違反

## 3. Frontend（Vitest + Testing Library）
- Health Panel
  - ボタン押下で fetch('/health') が呼ばれる
  - レスポンスに応じて表示文言/色が更新
  - JSON展開の有無（aria-labelで判定）

## 4. 実行
- RSpec
```bash
docker compose exec backend bash -lc "RAILS_ENV=test bundle exec rspec --format documentation"
```
- Vitest
```bash
docker compose exec frontend sh -lc "npm test -- --run"
```
