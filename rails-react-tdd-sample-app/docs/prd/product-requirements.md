# PRD — 実現したいこと

- Backend（/health）: サービス全体と主要コンポーネント（db / storage / auth）の状態を返す。全体は ok / degraded。応答に server time と commit を含める。
- Frontend（Health パネル）: トップ画面で全体と各コンポーネントの状態を色分け表示。更新ボタンで /health を再取得し、JSONも確認できる。
- Auth（Skeleton）: サインインAPIの最小スタブ。正しい入力で token を返し、誤りはエラーを返す。
- テスト: Backend は RSpec、Frontend は Vitest で初期UTが Green。/health はブラウザ確認とUI表示ができる。
