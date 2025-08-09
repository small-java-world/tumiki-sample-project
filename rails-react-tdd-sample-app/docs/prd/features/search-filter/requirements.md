# Feature PRD — Search & Filter

## Outcome
- 状態履歴やレコードから、必要な情報を素早く絞り込める

## Success Metrics
- キーワード検索とフィルタ（OK/Degraded/エラー種別）を提供
- 3件以上の一致があるときに、上位一致が分かる

## Scenarios
- キーワード入力で履歴を検索
- 状態種別（OK/Degraded）でフィルタ
- 検索とフィルタの組合せ

## Thin Slices
1) 種別フィルタ（OK/Degraded）
2) キーワード検索
3) 複合条件・ハイライト

## Tsumiki Seeds
- /kairo-tasks Search & Filter を3〜5タスクへ
- /tdd-testcases Red（フィルタ・検索・複合）
- /tdd-red → /tdd-green → /tdd-refactor
