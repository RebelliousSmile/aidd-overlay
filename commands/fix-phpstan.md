# Fix PHPStan

Fix PHPStan errors by running analysis, identifying issues, and applying corrections iteratively until 0 errors remain.

## Usage

```
/fix-phpstan
```

Or manually:
```bash
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
Runs `composer phpstan` (level 5) on:
- `code/src/` directory
- `code/apis/` directory
- `code/clients/` directory

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
- Prefixes: `client_`, `api_`, `sync_`, `db_`, etc.
- PHPDoc format standardized

### 4. Iterative Correction
The command runs in a loop:
```
Run PHPStan → Parse errors → Create TODO → Fix errors → Verify → Repeat
```

Stops when: `Found 0 errors`

## Output

The command provides:

### Progress Report
```
=== PHPStan Fix - Iteration 1 ===

Errors found: 6
- clients/halpades_functions.php: 4 errors
- src/migrations/20251003105949_exemple_migration.php: 2 errors

Creating TODO list...
- Fix function.notFound in clients/halpades_functions.php:263
- Fix function.notFound in clients/halpades_functions.php:267
- Fix function.notFound in clients/halpades_functions.php:271
- Fix function.notFound in clients/halpades_functions.php:339
- Fix catch.neverThrown in src/migrations/20251003105949_exemple_migration.php:21
- Fix catch.neverThrown in src/migrations/20251003105949_exemple_migration.php:42

Applying fixes...
✓ Fixed function.notFound (added require_once)
✓ Fixed catch.neverThrown (removed dead catch)

Re-running PHPStan...
```

### Final Report
```
=== PHPStan Fix Complete ===

Total iterations: 3
Errors fixed: 6
Files modified: 2

✅ PHPStan analysis: 0 errors

All files now comply with PHPStan level 5 and PHPDoc standards.
```

## Error Type Handling

### function.notFound
**Issue:** Function called but not defined/imported

**Fix:**
- Add `require_once` for the file containing the function
- Verify function exists in codebase
- If not exists, suggest creating stub

### Missing PHPDoc
**Issue:** Function lacks proper documentation

**Fix:**
```php
// Before
function process_data($data) {
    return $data;
}

// After
/**
 * Process data and return result
 *
 * @param mixed $data Data to process
 * @return mixed Processed data
 */
function process_data($data) {
    return $data;
}
```

### catch.neverThrown
**Issue:** Catch block for exception that's never thrown

**Fix:**
- Remove unnecessary catch block
- Or add proper exception handling in try block

### Missing type hints
**Issue:** Parameters or return types not specified

**Fix:**
```php
// Before
function get_user($id) {
    return [];
}

// After
/**
 * Get user by ID
 *
 * @param int $id User ID
 * @return array User data
 */
function get_user(int $id): array {
    return [];
}
```

## Configuration

Uses `phpstan.neon` configuration:
- **Level:** 5 (strict)
- **Paths:** src/, apis/, clients/
- **Excludes:** vendor/, tests/

## Safety Features

- ✅ **Backup before changes** - Creates git stash if needed
- ✅ **Incremental fixes** - One error type at a time
- ✅ **Verification after each fix** - Re-runs PHPStan
- ✅ **Max iterations limit** - Stops after 10 iterations if stuck
- ✅ **Rollback on failure** - Can restore from backup

## Best Practices

The command enforces:
- ✅ All functions have PHPDoc
- ✅ All parameters are typed
- ✅ All returns are typed
- ✅ No dead code (unreachable catches)
- ✅ No undefined functions
- ✅ Consistent naming conventions

## Example

### Before
```php
function client_halpades_handle_process($params) {
    $result = api_msexchange_sync_emails($clientName, $config, $forceRefresh);
    return $result;
}
```

**PHPStan errors:**
- Missing PHPDoc
- Missing type hints
- Undefined function `api_msexchange_sync_emails`

### After
```php
/**
 * Handler pour la route process-halpades
 * Synchronisation forcée sans cache
 *
 * @param array $params Paramètres de la requête
 * @return array Résultat de la synchronisation
 */
function client_halpades_handle_process(array $params): array
{
    require_once __DIR__ . '/../apis/msexchange_functions.php';

    $clientName = 'halpades';
    $config = api_msexchange_get_config($clientName);
    $forceRefresh = $params['force_refresh'] ?? false;

    $result = api_msexchange_sync_emails($clientName, $config, $forceRefresh);
    return $result;
}
```

**PHPStan:** ✅ 0 errors

## Limitations

- Cannot fix logical errors (only syntax/type issues)
- May need manual intervention for complex type issues
- Some errors may require architectural changes

## See Also

- `composer phpstan` - Run PHPStan manually
- `documentation/developpement/bonnes-pratiques.md` - Coding standards
- `documentation/developpement/conventions-nommage.md` - Naming conventions
