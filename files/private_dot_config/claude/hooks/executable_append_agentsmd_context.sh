#!/usr/bin/env sh
## @file append_agentsmd_context.sh
## Finds and prints all AGENTS.md files in the project directory for Claude context.
##
## Usage:
##     append_agentsmd_context.sh
##
## This is a temporary solution for cases where Claude Code does not satisfy AGENTS.md usage.
## via: https://github.com/anthropics/claude-code/issues/6235#issuecomment-3218728961

set -euo pipefail

# Find all AGENTS.md files in current directory and subdirectories
# This is a temporay solution for case that Claude Code not satisfies with AGENTS.md usage case.
echo "=== AGENTS.md Files Found ==="
find "$CLAUDE_PROJECT_DIR" -name "AGENTS.md" -type f | while read -r file; do
    echo "--- File: $file ---"
    cat "$file"
    echo ""
done
