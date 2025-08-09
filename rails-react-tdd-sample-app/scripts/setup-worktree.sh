#!/bin/bash

# ===========================================
# Git Worktree Setup Script
# ===========================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌳 Git Worktree Setup for Tsumiki Sample Project${NC}"
echo "=============================================="

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed${NC}"
    exit 1
fi

# Get current directory name
PROJECT_NAME=$(basename "$PWD")
BARE_REPO_NAME="${PROJECT_NAME}-bare"

echo -e "${YELLOW}📁 Current project: ${PROJECT_NAME}${NC}"

# Check if we're already in a worktree setup
if [ -f .git ] && grep -q "gitdir:" .git; then
    echo -e "${GREEN}✅ Already in a worktree setup${NC}"
    git worktree list
    exit 0
fi

# Create bare repository
echo -e "${BLUE}🏗️  Creating bare repository...${NC}"
cd ..
git clone --bare "$(cd "$PROJECT_NAME" && git remote get-url origin)" "$BARE_REPO_NAME"
cd "$BARE_REPO_NAME"

# Create worktrees for main branches
echo -e "${BLUE}🌲 Creating worktrees...${NC}"

# Main branch worktree
if git branch -r | grep -q "origin/main"; then
    git worktree add ../main main
    echo -e "${GREEN}✅ Created worktree: main${NC}"
elif git branch -r | grep -q "origin/master"; then
    git worktree add ../master master
    echo -e "${GREEN}✅ Created worktree: master${NC}"
fi

# Development branch worktree
if git branch -r | grep -q "origin/develop"; then
    git worktree add ../develop develop
    echo -e "${GREEN}✅ Created worktree: develop${NC}"
else
    # Create develop branch if it doesn't exist
    git worktree add -b develop ../develop
    echo -e "${GREEN}✅ Created worktree: develop (new branch)${NC}"
fi

# Feature branch worktree template
git worktree add -b feature/example ../feature-example
echo -e "${GREEN}✅ Created worktree: feature/example${NC}"

# List all worktrees
echo -e "${BLUE}📋 Current worktrees:${NC}"
git worktree list

echo ""
echo -e "${GREEN}🎉 Git worktree setup complete!${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. cd ../main (or ../master)"
echo "2. Continue development in respective directories"
echo "3. Use 'git worktree add -b feature/new-feature ../feature-new-feature' for new features"
echo ""
echo -e "${BLUE}📚 Worktree structure:${NC}"
echo "├── ${BARE_REPO_NAME}/ (bare repository)"
echo "├── main/ (main branch worktree)"
echo "├── develop/ (develop branch worktree)"
echo "└── feature-example/ (feature branch worktree)"