#!/bin/bash
# Prepare code review by gathering stats and changes
# Usage: ./pre-review.sh [branch|module|file]

TARGET="${1:-HEAD~1}"
CODE_DIR="/home/tnn/Projets/SmartLockers/middleware/code"

echo "=== Code Review Preparation ==="
echo "Target: $TARGET"
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Detect if target is a branch, module, or file
if [ -f "$TARGET" ]; then
    MODE="file"
    FILES="$TARGET"
elif [ -d "$CODE_DIR/clients" ] && echo "$TARGET" | grep -qE "^(onet|cosyhosting|halpades|lockandchill)$"; then
    MODE="module"
    case "$TARGET" in
        onet)
            FILES="$CODE_DIR/clients/onet_functions.php $CODE_DIR/apis/pilotphone_functions.php $CODE_DIR/apis/planet_functions.php"
            ;;
        cosyhosting)
            FILES="$CODE_DIR/clients/cosyhosting_functions.php $CODE_DIR/apis/guesty_functions.php"
            ;;
        halpades)
            FILES="$CODE_DIR/clients/halpades_functions.php $CODE_DIR/apis/msexchange_functions.php"
            ;;
        lockandchill)
            FILES="$CODE_DIR/clients/lockandchill_functions.php $CODE_DIR/apis/beds24_functions.php"
            ;;
    esac
else
    MODE="branch"
    FILES=""
fi

echo "Mode: $MODE"
echo ""

# Branch mode - show git diff
if [ "$MODE" = "branch" ]; then
    echo "## Changed Files"
    git diff "$TARGET" --name-status 2>/dev/null || git diff HEAD~1 --name-status
    echo ""

    echo "## Stats"
    git diff "$TARGET" --stat 2>/dev/null || git diff HEAD~1 --stat
    echo ""

    echo "## Recent Commits"
    git log "$TARGET"..HEAD --oneline 2>/dev/null || git log -5 --oneline
fi

# Module or file mode - show file stats
if [ "$MODE" = "module" ] || [ "$MODE" = "file" ]; then
    echo "## Files to Review"
    for f in $FILES; do
        if [ -f "$f" ]; then
            LINES=$(wc -l < "$f")
            FUNCS=$(grep -c "^function " "$f" 2>/dev/null || echo "0")
            echo "- $f ($LINES lines, $FUNCS functions)"
        else
            echo "- $f (NOT FOUND)"
        fi
    done
fi

echo ""
echo "## PHPStan Status"
cd "$CODE_DIR" 2>/dev/null && composer phpstan --no-interaction 2>&1 | tail -5

echo ""
echo "=== Ready for Review ==="
