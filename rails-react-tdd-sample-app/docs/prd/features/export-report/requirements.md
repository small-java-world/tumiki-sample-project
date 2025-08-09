# Feature PRD — Export Report

## Outcome
- 現在の状態スナップショットを、他者と共有できる形で書き出せる

## Success Metrics
- 1操作でJSON/Markdownのどちらかを保存できる
- ファイルには時刻/コミットID/overall/主要コンポーネント状態を含む

## Scenarios
- 画面の「Export」操作で、JSONまたはMarkdownがダウンロードされる
- Markdownには主要値の表と生JSONが含まれる

## Thin Slices
1) JSON保存（ファイル名に時刻とcommitを含める）
2) Markdown保存（表＋JSON）

## Tsumiki Seeds
- /kairo-tasks Export Report を2〜4タスクへ分割
- /tdd-testcases Red（JSON/Markdownの内容検証）
- /tdd-red スライス1 Red
- /tdd-green スライス1 Green
- /tdd-refactor スライス1 整理
