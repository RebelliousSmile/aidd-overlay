#!/bin/bash
# Check memory-bank integrity
# Usage: ./check-memory.sh

CLAUDE_MD="/home/tnn/Projets/SmartLockers/middleware/CLAUDE.md"
DOC_DIR="/home/tnn/Projets/SmartLockers/middleware/documentation"

echo "=== Memory Bank Health Check ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Check CLAUDE.md exists
if [ ! -f "$CLAUDE_MD" ]; then
    echo "❌ CLAUDE.md not found!"
    exit 1
fi

echo "## Referenced Files"
VALID=0
MISSING=0
DUPLICATES=0

# Extract @documentation/ references
REFS=$(grep -oE '@documentation/[^[:space:]]+' "$CLAUDE_MD" 2>/dev/null | sort)

if [ -z "$REFS" ]; then
    echo "No @documentation/ references found in CLAUDE.md"
else
    # Check each reference
    for ref in $REFS; do
        FILE_PATH="$DOC_DIR/${ref#@documentation/}"

        # Count occurrences
        COUNT=$(echo "$REFS" | grep -c "^$ref$")

        if [ -f "$FILE_PATH" ]; then
            SIZE=$(wc -c < "$FILE_PATH")
            TOKENS=$((SIZE / 4))  # Rough estimate
            if [ "$COUNT" -gt 1 ]; then
                echo "⚠️  DUPLICATE ($COUNT times): $ref (~${TOKENS} tokens)"
                ((DUPLICATES++))
            else
                echo "✅ $ref (~${TOKENS} tokens)"
            fi
            ((VALID++))
        else
            echo "❌ MISSING: $ref"
            ((MISSING++))
        fi
    done
fi

echo ""
echo "## Summary"
echo "- Valid files: $VALID"
echo "- Missing files: $MISSING"
echo "- Duplicates: $DUPLICATES"

echo ""
echo "## Directory Sizes"
for dir in memory-bank notebooks guides diagrams tasks reviews reports wireframes; do
    if [ -d "$DOC_DIR/$dir" ]; then
        FILE_COUNT=$(find "$DOC_DIR/$dir" -type f -name "*.md" | wc -l)
        SIZE=$(du -sh "$DOC_DIR/$dir" 2>/dev/null | cut -f1)
        echo "- $dir/: $FILE_COUNT files, $SIZE"
    else
        echo "- $dir/: (not found)"
    fi
done

echo ""
echo "## Old Files (> 30 days)"
find "$DOC_DIR/reviews" "$DOC_DIR/tasks" -name "*.md" -mtime +30 2>/dev/null | head -10

echo ""
if [ "$MISSING" -eq 0 ] && [ "$DUPLICATES" -eq 0 ]; then
    echo "✅ Memory bank is healthy"
    exit 0
else
    echo "⚠️  Issues detected - run /documentation-sync optimize"
    exit 1
fi
