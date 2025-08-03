# 🌳 Git Worktree Scripts

このディレクトリには、Git worktreeを使った並行開発環境をセットアップ・管理するためのスクリプトが含まれています。

## 📋 スクリプト一覧

### セットアップスクリプト
- `setup-worktree.sh` - Linux/Mac用セットアップスクリプト
- `setup-worktree.ps1` - Windows PowerShell用セットアップスクリプト

### ヘルパースクリプト
- `worktree-helper.sh` - Linux/Mac用管理スクリプト
- `worktree-helper.ps1` - Windows PowerShell用管理スクリプト

## 🚀 使用方法

### Windows
```powershell
# セットアップ
.\scripts\setup-worktree.ps1

# 機能ブランチ作成
.\scripts\worktree-helper.ps1 feature user-auth

# ステータス確認
.\scripts\worktree-helper.ps1 status
```

### Linux/Mac
```bash
# 実行権限付与
chmod +x scripts/*.sh

# セットアップ
./scripts/setup-worktree.sh

# 機能ブランチ作成
./scripts/worktree-helper.sh feature user-auth

# ステータス確認
./scripts/worktree-helper.sh status
```

## ✨ 機能

- 🏗️ **自動セットアップ**: ベアリポジトリとworktreeの自動作成
- 🌟 **機能ブランチ**: `feature/` ブランチの簡単作成
- 🚨 **ホットフィックス**: `hotfix/` ブランチの緊急作成
- 📊 **ステータス確認**: 全worktreeの状況を一覧表示
- 🔄 **同期機能**: 全worktreeのリモート同期
- 🧹 **クリーンアップ**: 不要なworktreeの削除