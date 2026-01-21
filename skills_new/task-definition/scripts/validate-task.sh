#!/bin/bash
# Validate task definition completeness
# Usage: ./validate-task.sh <task-file.md>

TASK_FILE="$1"

if [ -z "$TASK_FILE" ] || [ ! -f "$TASK_FILE" ]; then
    echo "Usage: $0 <task-file.md>"
    exit 1
fi

echo "=== Task Validation: $(basename "$TASK_FILE") ==="
echo ""

ERRORS=0
WARNINGS=0

# Check required sections
check_section() {
    local section="$1"
    local required="$2"

    if grep -q "^## $section" "$TASK_FILE" || grep -q "^# $section" "$TASK_FILE"; then
        echo "✅ Section: $section"
    else
        if [ "$required" = "required" ]; then
            echo "❌ MISSING: $section"
            ((ERRORS++))
        else
            echo "⚠️  Optional missing: $section"
            ((WARNINGS++))
        fi
    fi
}

# Required sections
check_section "Description" "required"
check_section "Acceptance Criteria" "required"
check_section "Technical Requirements" "required"
check_section "Definition of Done" "required"

# Optional sections
check_section "Risques" "optional"
check_section "Tests" "optional"
check_section "Analyse technique" "optional"

echo ""

# Check acceptance criteria format
AC_COUNT=$(grep -c "^\- \[ \]" "$TASK_FILE" 2>/dev/null || echo "0")
if [ "$AC_COUNT" -gt 0 ]; then
    echo "✅ Acceptance criteria: $AC_COUNT items"
else
    echo "❌ No acceptance criteria checkboxes found"
    ((ERRORS++))
fi

# Check PHPStan mention
if grep -qi "phpstan" "$TASK_FILE"; then
    echo "✅ PHPStan validation mentioned"
else
    echo "⚠️  PHPStan not mentioned"
    ((WARNINGS++))
fi

# Check files to modify
if grep -q "Fichiers à modifier\|Files to" "$TASK_FILE"; then
    echo "✅ Files to modify section present"
else
    echo "⚠️  No 'files to modify' section"
    ((WARNINGS++))
fi

# Check title format (should start with action verb)
TITLE=$(head -1 "$TASK_FILE" | sed 's/^# Task: //')
if echo "$TITLE" | grep -qE "^(Ajouter|Intégrer|Supprimer|Corriger|Créer|Modifier|Implémenter|Add|Create|Fix|Update|Remove|Implement)"; then
    echo "✅ Title is action-oriented: $TITLE"
else
    echo "⚠️  Title may not be action-oriented: $TITLE"
    ((WARNINGS++))
fi

echo ""
echo "=== Summary ==="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "❌ Task definition incomplete"
    exit 1
else
    echo ""
    echo "✅ Task definition valid"
    exit 0
fi
