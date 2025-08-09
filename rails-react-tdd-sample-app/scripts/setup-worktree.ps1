# Git Worktree Setup Script (PowerShell)
# Usage: .\scripts\setup-worktree.ps1

param([switch]$Help, [switch]$Force)

function Write-ColorOutput {
    param($Message, $Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

if ($Help) {
    Write-ColorOutput "🌳 Git Worktree Setup for Tsumiki Sample Project" "Cyan"
    Write-Host "=============================================="
    Write-Host "This script creates a bare repository and sets up worktrees for parallel development."
    Write-Host ""
    Write-Host "Usage: .\scripts\setup-worktree.ps1 [-Help] [-Force]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Help    Show this help message"
    Write-Host "  -Force   Force setup even if worktree already exists"
    exit 0
}

Write-ColorOutput "🌳 Git Worktree Setup Starting..." "Cyan"

# Check if git is installed
try {
    $gitVersion = git --version
    Write-ColorOutput "✅ Git found: $gitVersion" "Green"
} catch {
    Write-ColorOutput "❌ Git is not installed" "Red"
    exit 1
}

# Get current directory and setup paths
$currentDir = Split-Path -Leaf (Get-Location)
$bareRepoName = "$currentDir-bare"

Write-ColorOutput "📁 Setting up worktrees for: $currentDir" "Yellow"

# Basic worktree setup commands
Write-ColorOutput "📋 Manual setup steps:" "Cyan"
Write-Host "1. cd .."
Write-Host "2. git clone --bare <remote-url> $bareRepoName"
Write-Host "3. cd $bareRepoName"
Write-Host "4. git worktree add ../main main"
Write-Host "5. git worktree add -b develop ../develop"

Write-ColorOutput "💡 Use .\scripts\worktree-helper.ps1 for branch management." "Green"