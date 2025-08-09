# Feature PRD — In‑App Notifications

## Outcome
- 重要な状態変化（Degraded/復旧/エラー）を、アプリ内で分かりやすく通知する

## Success Metrics
- 通知は目に留まりやすい表示（トースト/バナー）で、1クリックで閉じられる
- 同種イベントの重複通知を抑制（一定時間内）

## Scenarios
- Degraded発生時にバナー表示（要約＋詳細リンク）
- 復旧時にOK通知
- 取得失敗時にエラー通知

## Thin Slices
1) トースト/バナーの共通コンポーネント
2) Degraded/復旧/エラーのトリガ連携
3) 重複通知の抑制（クールダウン）

## Tsumiki Seeds
- /kairo-tasks Notifications を3〜6タスクへ
- /tdd-testcases Red（表示/閉じる/抑制）
- /tdd-red → /tdd-green → /tdd-refactor
