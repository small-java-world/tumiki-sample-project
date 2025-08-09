# API Contracts — rails-react-tdd-sample-app

## GET /health
- 目的: 全体および主要コンポーネントの健全性を可視化
- レスポンス例
```json
{
  "status": "ok",               
  "components": { "db": "ok", "storage": "ok", "auth": "degraded" },
  "metrics": { "dbMs": 12, "storageMs": 34, "authMs": 1200 },
  "time": "2025-08-09T03:10:00Z",
  "commit": "local"
}
```
- status: ok | degraded
- components: 各コンポーネントの状態（ok | degraded | down）
- metrics: ms計測（任意）

## POST /auth/sign_in
- 目的: 認証の骨組み（スタブ）
- リクエスト
```json
{ "email": "a@b.com", "password": "secret" }
```
- 成功(200)
```json
{ "token": "stub-token", "exp": 3600 }
```
- 失敗(400)
```json
{ "error": "invalid_credentials" }
```
- バリデーション: email必須、password必須（長さ > 0）
