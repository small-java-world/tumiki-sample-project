# Non-Functional Requirements — rails-react-tdd-sample-app

## 性能
- /health: p95 < 200ms（依存のdegraded時を除く）
- Frontend初期描画: 開発時は 2s 以内

## 可用性
- docker compose 再起動で復帰できること
- 依存が落ちても /health は200で degraded応答（監視互換）

## セキュリティ
- 機密情報はログやレスポンスに含めない（filter_parameter_logging）
- CORSはフロント開発URLのみ許可

## 運用
- .envでポート/プロジェクト名を切替え、worktree並行時の衝突回避
- ログは必要最小限、レベルはinfo/warn/error
