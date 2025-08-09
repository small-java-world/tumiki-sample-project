# Feature PRD — Auth Skeleton

## Outcome
- 認証有り前提の画面/APIが動くための最小要素を提供（成功/失敗の往復が成り立つ）

## Success Metrics
- 正常入力で成功応答（token/exp）を返せる
- 不正入力でわかりやすいエラーを返せる
- 入力必須と形式の基本バリデーションを満たす

## Scenarios
- メール/パスワードの入力と送信
- 成功時のセッション扱い（画面側の保持方針は後続）
- 失敗時のエラー表示

## Thin Slices
1) 入力項目と基本バリデーション
2) 成功/失敗の最小応答（スタブ）
3) 画面側の成功/失敗表示

## Tsumiki Seeds
- /kairo-tasks Auth Skeleton を3〜5タスクへ分割
- /tdd-testcases Red（200/400の分岐、バリデーション）
- /tdd-red スライス1 Red
- /tdd-green スライス1 Green
- /tdd-refactor スライス1 整理
