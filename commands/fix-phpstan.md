# Fix PHPStan

Fix PHPStan errors by running analysis, identifying issues, and applying corrections iteratively until 0 errors remain.

---

## 🚨 CRITICAL INSTRUCTION for Claude

**BEFORE executing any command, you MUST navigate to the `code/` directory**:

```bash
cd /home/tnn/Projets/SmartLockers/middleware/code
```

**All PHPStan commands execute from `code/`**:
```bash
cd code/
composer phpstan     # PHPStan analysis
composer test        # Tests
composer quality     # PHPStan + Tests
```

**NEVER execute from project root (`/middleware/`)** ❌

---

## Usage

```
/fix-phpstan
```

Or manually:
```bash
cd code/
composer phpstan  # See current errors
# Then fix errors manually or ask Claude to fix them
```

## Process

The recommended approach is to work with Claude iteratively:

1. **Run PHPStan**: `composer phpstan`
2. **Share output with Claude**: Copy/paste errors
3. **Claude analyzes and fixes**: Identifies error types and applies corrections
4. **Verify**: Re-run PHPStan
5. **Repeat**: Until 0 errors

This command documents the process and common fixes.

## What It Does

### 1. PHPStan Analysis
Runs `composer phpstan` (level 5) from `code/` directory on:
- `src/` directory
- `apis/` directory
- `clients/` directory

**Executed command**:
```bash
cd code/
composer phpstan
```

### 2. Error Detection
Identifies common PHPStan errors:
- **Missing PHPDoc** - Functions without proper documentation
- **Missing type hints** - Parameters/returns without types
- **Undefined functions** - Function calls to non-existent functions
- **Dead catches** - Unreachable catch blocks
- **Invalid types** - Type mismatches
- **Missing properties** - Undefined class properties

### 3. Automatic Fixes
Applies fixes according to project conventions:

#### PHPDoc Standards
```php
/**
 * Description of what the function does
 *
 * @param string $param1 Description of param1
 * @param array $param2 Description of param2
 * @return array Description of return value
 * @throws Exception When error occurs
 */
function example_function(string $param1, array $param2): array
{
    // Implementation
}
```

#### Function Declarations
- Ensures all functions have proper type hints
- Adds return types when missing
- Documents all parameters

#### Nomenclature Compliance
- Follows `snake_case` for functions
- Uses proper prefixes: `client_`, `api_`, `provider_`, `db_`, `auth_`

## Common Fixes

### Missing PHPDoc
**Error**: "Function has no PHPDoc"
**Fix**: Add complete PHPDoc block with params, return, throws

### Missing Type Hints
**Error**: "Parameter $x has no type"
**Fix**: Add type hint based on usage in function

### Undefined Function
**Error**: "Function xyz() not found"
**Fix**: Add `require_once` for the file containing the function

## Iterative Loop

```bash
while [ "$(composer phpstan 2>&1 | grep 'errors')" != "" ]; do
  composer phpstan
  # Apply fixes
  # Re-check
done
```

Target: **0 PHPStan errors**
