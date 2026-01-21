#!/bin/bash
# Display skill usage statistics
# Usage: ./show-skill-stats.sh [days]

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/skill-usage.log"

DAYS=${1:-30}

if [ ! -f "$LOG_FILE" ]; then
    echo "No usage data yet. Log file: $LOG_FILE"
    exit 0
fi

echo "=== Skill/Command Usage Statistics (last $DAYS days) ==="
echo ""

# Filter by date range and count
CUTOFF_DATE=$(date -d "$DAYS days ago" '+%Y-%m-%d' 2>/dev/null || date -v-${DAYS}d '+%Y-%m-%d')

echo "## By frequency:"
grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}" "$LOG_FILE" | \
    awk -v cutoff="$CUTOFF_DATE" '$1 >= cutoff' | \
    grep -o 'skill: [^|]*' | \
    sed 's/skill: //' | \
    sort | uniq -c | sort -rn | \
    head -20

echo ""
echo "## By date:"
grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}" "$LOG_FILE" | \
    awk -v cutoff="$CUTOFF_DATE" '$1 >= cutoff' | \
    cut -d' ' -f1 | \
    sort | uniq -c | sort -r | \
    head -10

echo ""
echo "## Total invocations:"
wc -l < "$LOG_FILE" | tr -d ' '
