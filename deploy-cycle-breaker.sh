#!/bin/bash
# Deploy Cycle Breaker
# Runs git add, commit, and push from the cycle-breaker folder

set -e  # Exit immediately if any command fails

REPO_DIR="/Users/akiramartha/cycle-breaker"

echo "Deploy Cycle Breaker - starting..."
echo "Working directory: $REPO_DIR"
echo ""

cd "$REPO_DIR" || { echo "Error: Could not access $REPO_DIR"; exit 1; }

echo "Step 1/3: git add ."
git add .
echo ""

echo "Step 2/3: git commit -m \"auto deploy\""
# Use || true so it doesn't fail if there's nothing to commit
git commit -m "auto deploy" || echo "Nothing to commit (working tree clean)"
echo ""

echo "Step 3/3: git push"
git push
echo ""

echo "Deploy Cycle Breaker - done."
