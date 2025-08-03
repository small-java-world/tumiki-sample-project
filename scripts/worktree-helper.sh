#!/bin/bash

# ===========================================
# Git Worktree Helper Script
# ===========================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to show usage
show_help() {
    echo -e "${BLUE}🌳 Git Worktree Helper${NC}"
    echo "===================="
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  list                    List all worktrees"
    echo "  create <branch> <path>  Create new worktree"
    echo "  remove <path>           Remove worktree"
    echo "  feature <name>          Create feature branch worktree"
    echo "  hotfix <name>           Create hotfix branch worktree"
    echo "  switch <path>           Switch to worktree directory"
    echo "  status                  Show status of all worktrees"
    echo "  sync                    Sync all worktrees with remote"
    echo "  clean                   Clean up deleted branches"
    echo ""
    echo "Examples:"
    echo "  $0 feature user-auth"
    echo "  $0 hotfix critical-bug"
    echo "  $0 remove ../feature-old"
    echo "  $0 status"
}

# Function to list worktrees
list_worktrees() {
    echo -e "${BLUE}📋 Current worktrees:${NC}"
    git worktree list
}

# Function to create feature branch
create_feature() {
    local feature_name="$1"
    if [ -z "$feature_name" ]; then
        echo -e "${RED}❌ Feature name required${NC}"
        exit 1
    fi
    
    local branch_name="feature/$feature_name"
    local path="../feature-$feature_name"
    
    echo -e "${BLUE}🌟 Creating feature worktree: $branch_name${NC}"
    git worktree add -b "$branch_name" "$path"
    echo -e "${GREEN}✅ Created: $path${NC}"
    echo -e "${YELLOW}💡 To switch: cd $path${NC}"
}

# Function to create hotfix branch
create_hotfix() {
    local hotfix_name="$1"
    if [ -z "$hotfix_name" ]; then
        echo -e "${RED}❌ Hotfix name required${NC}"
        exit 1
    fi
    
    local branch_name="hotfix/$hotfix_name"
    local path="../hotfix-$hotfix_name"
    
    echo -e "${BLUE}🚨 Creating hotfix worktree: $branch_name${NC}"
    git worktree add -b "$branch_name" "$path" main
    echo -e "${GREEN}✅ Created: $path${NC}"
    echo -e "${YELLOW}💡 To switch: cd $path${NC}"
}

# Function to create custom worktree
create_worktree() {
    local branch_name="$1"
    local path="$2"
    
    if [ -z "$branch_name" ] || [ -z "$path" ]; then
        echo -e "${RED}❌ Branch name and path required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🌲 Creating worktree: $branch_name -> $path${NC}"
    git worktree add -b "$branch_name" "$path"
    echo -e "${GREEN}✅ Created: $path${NC}"
}

# Function to remove worktree
remove_worktree() {
    local path="$1"
    if [ -z "$path" ]; then
        echo -e "${RED}❌ Path required${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🗑️  Removing worktree: $path${NC}"
    git worktree remove "$path"
    echo -e "${GREEN}✅ Removed: $path${NC}"
}

# Function to show status of all worktrees
show_status() {
    echo -e "${BLUE}📊 Worktree Status Report${NC}"
    echo "========================"
    
    git worktree list | while read -r line; do
        path=$(echo "$line" | awk '{print $1}')
        branch=$(echo "$line" | awk '{print $2}' | tr -d '[]')
        
        if [ -d "$path" ]; then
            echo ""
            echo -e "${YELLOW}📁 $path ($branch)${NC}"
            cd "$path"
            
            # Show git status
            if git status --porcelain | grep -q .; then
                echo -e "${RED}  🔄 Has changes${NC}"
                git status --short | head -5
            else
                echo -e "${GREEN}  ✅ Clean${NC}"
            fi
            
            # Show commits ahead/behind
            if git status -b --porcelain | grep -q "ahead\|behind"; then
                echo -e "${BLUE}  📡 $(git status -b --porcelain | head -1 | cut -d' ' -f2-)${NC}"
            fi
        fi
    done
}

# Function to sync all worktrees
sync_worktrees() {
    echo -e "${BLUE}🔄 Syncing all worktrees...${NC}"
    
    git worktree list | while read -r line; do
        path=$(echo "$line" | awk '{print $1}')
        branch=$(echo "$line" | awk '{print $2}' | tr -d '[]')
        
        if [ -d "$path" ] && [ "$branch" != "(bare)" ]; then
            echo -e "${YELLOW}🔄 Syncing $path ($branch)${NC}"
            cd "$path"
            git fetch origin
            
            if git status -b --porcelain | grep -q "behind"; then
                echo -e "${BLUE}  📥 Pulling latest changes${NC}"
                git pull origin "$branch" || echo -e "${RED}  ❌ Pull failed${NC}"
            else
                echo -e "${GREEN}  ✅ Up to date${NC}"
            fi
        fi
    done
}

# Function to clean up deleted branches
clean_worktrees() {
    echo -e "${BLUE}🧹 Cleaning up worktrees...${NC}"
    git worktree prune
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

# Main script logic
case "${1:-help}" in
    "list"|"ls")
        list_worktrees
        ;;
    "create")
        create_worktree "$2" "$3"
        ;;
    "remove"|"rm")
        remove_worktree "$2"
        ;;
    "feature"|"feat")
        create_feature "$2"
        ;;
    "hotfix"|"fix")
        create_hotfix "$2"
        ;;
    "status")
        show_status
        ;;
    "sync")
        sync_worktrees
        ;;
    "clean")
        clean_worktrees
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac