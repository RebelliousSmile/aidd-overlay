#!/bin/bash
# Track skill/command usage for analytics
# Logs each invocation to .claude/logs/skill-usage.log

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/skill-usage.log"

# Create log directory if needed
mkdir -p "$LOG_DIR"

# Read hook input from stdin
INPUT=$(cat)

# Extract skill name from JSON input
# Input format: {"tool_name": "Skill", "tool_input": {"skill": "name", "args": "..."}}
SKILL_NAME=$(echo "$INPUT" | grep -o '"skill"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"skill"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
SKILL_ARGS=$(echo "$INPUT" | grep -o '"args"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"args"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Get timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DATE_KEY=$(date '+%Y-%m-%d')

# Log the usage
if [ -n "$SKILL_NAME" ]; then
    echo "$TIMESTAMP | skill: $SKILL_NAME | args: $SKILL_ARGS" >> "$LOG_FILE"
fi

# Exit successfully (don't block the tool)
exit 0
