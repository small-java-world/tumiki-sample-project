# Feature PRD — Health Panel

## Outcome
- 利用者が画面だけでシステムの健全性と更新タイミングを正しく理解できる

## Success Metrics
- 状態表示（OK/Degraded）と各コンポーネントの状態が色/アイコンで判別可能
- 「更新」操作で1回の操作あたり1秒以内に表示が更新される（開発環境）
- 生JSONの確認手段があり、調査時にコピーできる

## Scenarios
- 初期表示で現在時刻/最新状態が見える
- 更新ボタンで状態が更新される
- Degraded時に担当コンポーネントが識別できる
- 取得失敗時は簡潔なエラーメッセージ

## Constraints / Non‑Goals
- デザインの高度化やダークモードは対象外
- 自動更新は後続スライス

## Thin Slices
1) タイトル/現在時刻/全体状態表示
2) 各コンポーネントの状態表示と色分け
3) 更新ボタンとJSON展開

## Tsumiki Seeds
- /kairo-tasks Health Panel を上記スライスで分割
- /tdd-testcases スライス1〜2のRedテスト
- /tdd-red スライス1 Red
- /tdd-green スライス1 Green
- /tdd-refactor スライス1 整理
