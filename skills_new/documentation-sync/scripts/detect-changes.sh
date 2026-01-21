#!/bin/bash
# Detect code changes that need documentation sync
# Usage: ./detect-changes.sh [git-range]

RANGE="${1:-HEAD~1..HEAD}"
CODE_DIR="/home/tnn/Projets/SmartLockers/middleware/code"

echo "=== Documentation Sync: Change Detection ==="
echo "Range: $RANGE"
echo "Date: $(date '+%Y-%MM-%d %H:%M')"
echo ""

# Get changed files
CHANGED_FILES=$(git diff "$RANGE" --name-only 2>/dev/null)

if [ -z "$CHANGED_FILES" ]; then
    echo "No changes detected in range: $RANGE"
    exit 0
fi

echo "## Changed Files"
echo "$CHANGED_FILES" | while read -r file; do
    if [ -n "$file" ]; then
        STATS=$(git diff "$RANGE" --stat -- "$file" 2>/dev/null | tail -1)
        echo "- $file ($STATS)"
    fi
done
echo ""

# Categorize changes
echo "## Documentation Impact"
echo ""

echo "### Client Code (→ notebooks/client/)"
echo "$CHANGED_FILES" | grep -E "^code/clients/.*\.php$" || echo "(none)"
echo ""

echo "### API Code (→ notebooks/api/)"
echo "$CHANGED_FILES" | grep -E "^code/apis/.*\.php$" || echo "(none)"
echo ""

echo "### Database (→ notebooks/architecture/database/)"
echo "$CHANGED_FILES" | grep -E "^code/src/migrations/.*\.php$" || echo "(none)"
echo ""

echo "### Routes (→ notebooks/api/README.md)"
echo "$CHANGED_FILES" | grep -E "^code/routes/.*\.php$" || echo "(none)"
echo ""

# Count new functions
echo "## New Functions Detected"
for file in $(echo "$CHANGED_FILES" | grep "\.php$"); do
    if [ -f "$file" ]; then
        NEW_FUNCS=$(git diff "$RANGE" -- "$file" 2>/dev/null | grep "^+.*function " | grep -v "^+++" | wc -l)
        if [ "$NEW_FUNCS" -gt 0 ]; then
            echo "- $file: $NEW_FUNCS new function(s)"
            git diff "$RANGE" -- "$file" 2>/dev/null | grep "^+.*function " | grep -v "^+++" | sed 's/^+/  /'
        fi
    fi
done
echo ""

echo "=== Ready for sync ==="
