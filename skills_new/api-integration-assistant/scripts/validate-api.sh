#!/bin/bash
# Validate API Integration
# Usage: ./validate-api.sh <api_name>

API_NAME="${1:-}"

if [ -z "$API_NAME" ]; then
    echo "Usage: $0 <api_name>"
    exit 1
fi

echo "=== API Integration Validation: ${API_NAME} ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

ERRORS=0
WARNINGS=0

# 1. Check API functions file exists
API_FILE="code/apis/${API_NAME}_functions.php"
if [ -f "$API_FILE" ]; then
    echo "✅ API file exists: $API_FILE"

    # Check for required functions
    for func in "authenticate" "get_resource"; do
        if grep -q "function api_${API_NAME}_${func}" "$API_FILE"; then
            echo "  ✅ Function api_${API_NAME}_${func}() found"
        else
            echo "  ⚠️ Function api_${API_NAME}_${func}() NOT FOUND"
            ((WARNINGS++))
        fi
    done

    # Check for cache-first pattern
    if grep -q "api_resilient_call" "$API_FILE"; then
        echo "  ✅ Cache-first pattern (api_resilient_call) found"
    else
        echo "  ❌ Cache-first pattern NOT FOUND - REQUIRED for GET operations"
        ((ERRORS++))
    fi

    # Check PHPDoc
    FUNC_COUNT=$(grep -c "^function " "$API_FILE" 2>/dev/null || echo 0)
    DOC_COUNT=$(grep -c "@param\|@return" "$API_FILE" 2>/dev/null || echo 0)
    if [ "$DOC_COUNT" -ge "$FUNC_COUNT" ]; then
        echo "  ✅ PHPDoc appears complete ($DOC_COUNT annotations for $FUNC_COUNT functions)"
    else
        echo "  ⚠️ PHPDoc may be incomplete ($DOC_COUNT annotations for $FUNC_COUNT functions)"
        ((WARNINGS++))
    fi
else
    echo "❌ API file NOT FOUND: $API_FILE"
    ((ERRORS++))
fi

echo ""

# 2. Check contract tests
TEST_FILE="code/tests/contracts/test_api_${API_NAME}.php"
if [ -f "$TEST_FILE" ]; then
    echo "✅ Contract tests exist: $TEST_FILE"
else
    echo "⚠️ Contract tests NOT FOUND: $TEST_FILE"
    ((WARNINGS++))
fi

# 3. Check documentation
DOC_FILE="documentation/notebooks/api/${API_NAME}.md"
if [ -f "$DOC_FILE" ]; then
    echo "✅ Documentation exists: $DOC_FILE"
else
    echo "⚠️ Documentation NOT FOUND: $DOC_FILE"
    ((WARNINGS++))
fi

echo ""

# 4. Run PHPStan on API file
if [ -f "$API_FILE" ]; then
    echo "=== PHPStan Validation ==="
    cd code && composer phpstan -- --error-format=raw 2>/dev/null | grep -i "$API_NAME" || echo "✅ No PHPStan errors for ${API_NAME}"
    cd ..
fi

echo ""

# 5. Summary
echo "=== Summary ==="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo "✅ API ${API_NAME} validation PASSED"
    exit 0
elif [ "$ERRORS" -eq 0 ]; then
    echo "⚠️ API ${API_NAME} validation PASSED with warnings"
    exit 0
else
    echo "❌ API ${API_NAME} validation FAILED"
    exit 1
fi
