#!/bin/bash
# One-time setup: adds the "deploy-cb" alias to your shell config

set -e

SCRIPT_PATH="/Users/akiramartha/cycle-breaker/deploy-cycle-breaker.sh"
ALIAS_LINE="alias deploy-cb=\"$SCRIPT_PATH\""

# Detect shell config file (zsh is default on modern macOS, fall back to bash)
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
else
    RC_FILE="$HOME/.bash_profile"
fi

echo "Installing deploy-cb alias into: $RC_FILE"

# Make sure the deploy script exists and is executable
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH does not exist."
    echo "Move deploy-cycle-breaker.sh into /Users/akiramartha/cycle-breaker/ first."
    exit 1
fi
chmod +x "$SCRIPT_PATH"

# Only add the alias if it isn't already there
if grep -Fxq "$ALIAS_LINE" "$RC_FILE" 2>/dev/null; then
    echo "Alias already installed - no changes made."
else
    {
        echo ""
        echo "# Deploy Cycle Breaker workflow"
        echo "$ALIAS_LINE"
    } >> "$RC_FILE"
    echo "Alias added."
fi

echo ""
echo "Done. To start using it right now, run:"
echo "    source $RC_FILE"
echo ""
echo "Then from anywhere in Terminal you can deploy with:"
echo "    deploy-cb"
