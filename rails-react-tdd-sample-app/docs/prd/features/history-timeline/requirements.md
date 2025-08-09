# Feature PRD — History Timeline

## Outcome
- 直近の状態履歴（N件）を時系列で確認でき、変化点を把握できる

## Success Metrics
- 直近5〜10件の状態（overall/主要コンポーネント/時刻）が一覧できる
- 変化差分（OK→Degradedなど）が視覚的に分かる

## Scenarios
- 更新のたびに最新エントリが先頭に追加される
- Degradedになった/戻ったタイミングが識別できる
- 履歴はセッション内で保持（ページ移動で消えても可、永続化は後続）

## Thin Slices
1) 履歴の記録（最新N件保持）
2) 差分のハイライト表示
3) 並び替え/クリア操作

## Tsumiki Seeds
- /kairo-tasks History Timeline を3〜6タスクへ分割
- /tdd-testcases Red（記録・表示・差分強調）
- /tdd-red スライス1 Red
- /tdd-green スライス1 Green
- /tdd-refactor スライス1 整理
