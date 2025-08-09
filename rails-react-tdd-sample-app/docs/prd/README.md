# PRD Index — rails-react-tdd-sample-app

このフォルダは、本アプリの最小TDD対象の要件仕様（PRD: Product Requirements Document）をまとめます。
まず設計（PRD）を確定し、その後 3 worktree で並行TDD（Backend Deep Health / Frontend Health Panel / Auth Skeleton）を進めます。

構成:
- product-requirements.md: 目的・範囲・ユーザーストーリー・受け入れ基準
- api-contracts.md: API契約（/health, /auth/sign_in）
- test-plan.md: テスト方針（RSpec / Vitest）と観点
- non-functional.md: 非機能要件（性能・可用性・セキュリティ・運用）
- release-plan.md: worktree運用・ブランチ戦略・Done定義

更新ポリシー:
- TDDの Red → Green → Refactor サイクルに合わせて更新
- 仕様変更はPR（設計→実装→UT）で追跡し、PRDへ反映
