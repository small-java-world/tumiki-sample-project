# Git Worktree Helper Script (PowerShell)
# Usage: .\scripts\worktree-helper.ps1 [command] [name]

param(
    [Parameter(Position=0)][string]$Command = "help",
    [Parameter(Position=1)][string]$Name
)

function Write-ColorOutput {
    param($Message, $Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColorOutput "🌳 Git Worktree Helper" "Cyan"
    Write-Host "Usage: .\scripts\worktree-helper.ps1 [COMMAND] [NAME]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  feature <name>    Create feature branch worktree"
    Write-Host "  hotfix <name>     Create hotfix branch worktree"
    Write-Host "  list              List all worktrees"
    Write-Host "  status            Show status of all worktrees"
    Write-Host "  help              Show this help"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\scripts\worktree-helper.ps1 feature user-auth"
    Write-Host "  .\scripts\worktree-helper.ps1 hotfix critical-bug"
    Write-Host "  .\scripts\worktree-helper.ps1 status"
}

function New-FeatureBranch {
    param($FeatureName)
    if (-not $FeatureName) {
        Write-ColorOutput "❌ Feature name required" "Red"
        return
    }
    
    $branchName = "feature/$FeatureName"
    $path = "..\feature-$FeatureName"
    
    Write-ColorOutput "🌟 Creating feature worktree: $branchName" "Cyan"
    try {
        git worktree add -b $branchName $path 2>$null
        Write-ColorOutput "✅ Created: $path" "Green"
        Write-ColorOutput "💡 To switch: cd $path" "Yellow"
    } catch {
        Write-ColorOutput "⚠️  Worktree creation: Use 'git worktree add -b $branchName $path' manually" "Yellow"
    }
}

function New-HotfixBranch {
    param($HotfixName)
    if (-not $HotfixName) {
        Write-ColorOutput "❌ Hotfix name required" "Red"
        return
    }
    
    $branchName = "hotfix/$HotfixName"
    $path = "..\hotfix-$HotfixName"
    
    Write-ColorOutput "🚨 Creating hotfix worktree: $branchName" "Cyan"
    Write-ColorOutput "💡 Use: git worktree add -b $branchName $path" "Yellow"
}

function Get-Worktrees {
    Write-ColorOutput "📋 Current worktrees:" "Cyan"
    try {
        git worktree list
    } catch {
        Write-ColorOutput "⚠️  Not in a git repository or worktree not set up" "Yellow"
    }
}

function Show-WorktreeStatus {
    Write-ColorOutput "📊 Worktree Status Report" "Cyan"
    Write-Host "========================"
    try {
        git worktree list
    } catch {
        Write-ColorOutput "⚠️  Worktree not set up. Run setup-worktree.ps1 first." "Yellow"
    }
}

# Main script logic
switch ($Command.ToLower()) {
    "feature" { New-FeatureBranch -FeatureName $Name }
    "hotfix" { New-HotfixBranch -HotfixName $Name }
    "list" { Get-Worktrees }
    "status" { Show-WorktreeStatus }
    "help" { Show-Help }
    default {
        Write-ColorOutput "❌ Unknown command: $Command" "Red"
        Show-Help
    }
}