# Feature PRD — User Preferences

## Outcome
- 利用者が自分の使いやすい設定（例: テーマ/自動更新間隔/表示密度）を選び、次回以降も維持できる

## Success Metrics
- 主要設定は3クリック以内に変更可能
- 設定は再訪時も保持（例: localStorage/後続でサーバ保持）

## Scenarios
- テーマ（ライト/ダーク）を切替
- 自動更新間隔を選択（5/10/30秒）またはオフ
- 表示密度（コンパクト/標準）を選択

## Thin Slices
1) 設定UIと即時反映
2) 設定の永続化（localStorage）
3) リセット（デフォルトへ戻す）

## Tsumiki Seeds
- /kairo-tasks User Preferences を3〜5タスクへ分割
- /tdd-testcases Red（切替反映・永続化・リセット）
- /tdd-red スライス1 Red → /tdd-green → /tdd-refactor
