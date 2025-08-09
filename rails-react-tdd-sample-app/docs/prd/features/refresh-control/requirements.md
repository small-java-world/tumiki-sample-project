# Feature PRD — Refresh Control

## Outcome
- 状態の自動更新を、ユーザーが任意の間隔でオン/オフできる

## Success Metrics
- 自動更新の切替と間隔設定が直感的に行える（3クリック以内）
- 設定は再訪時も維持される（例: localStorage）

## Scenarios
- 自動更新をオンにすると、指定間隔（例: 5/10/30秒）で最新状態が取得される
- オフに戻すと自動取得は止まり、手動更新のみになる
- 設定はページ再読込後も保持される

## Thin Slices
1) トグル（オン/オフ）と固定のデフォルト間隔
2) 間隔の選択（5/10/30秒）
3) 永続化（localStorage）

## Tsumiki Seeds
- /kairo-tasks Refresh Control を3〜5タスクへ分割（トグル/選択/永続化）
- /tdd-testcases Red（トグル動作、間隔変更、永続化の反映）
- /tdd-red スライス1 Red
- /tdd-green スライス1 Green
- /tdd-refactor スライス1 整理
