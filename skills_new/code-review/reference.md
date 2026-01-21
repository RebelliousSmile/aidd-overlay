# Code Review Reference - SmartLockers

Complete checklist and patterns for code reviews.

## Review Checklist

### 1. Functionality
- [ ] Code works as intended
- [ ] Edge cases handled (null, empty, invalid input)
- [ ] Error handling appropriate (try/catch, error_log)
- [ ] Return values match PHPDoc

### 2. Code Quality
- [ ] Follows naming conventions:
  - Functions: `snake_case` with prefixes (`client_`, `api_`, `provider_`, `db_`, `auth_`)
  - Variables: `snake_case` descriptive
- [ ] Clear and readable code
- [ ] No duplicated code (DRY)
- [ ] Functions are focused and small (< 50 lines ideal)
- [ ] No dead code or commented-out blocks

### 3. Security
- [ ] No sensitive data in logs or responses
- [ ] Input validation/sanitization present
- [ ] SQL injection prevention (prepared statements)
- [ ] XSS prevention (output encoding)
- [ ] Authentication/authorization checks correct
- [ ] JWT tokens validated properly

### 4. Performance
- [ ] No N+1 query problems
- [ ] Database queries optimized (indexes used)
- [ ] Caching used appropriately
- [ ] No unnecessary loops or iterations
- [ ] Async/parallel calls where beneficial

### 5. Testing
- [ ] PHPStan level 6 passes (0 errors)
- [ ] Contract tests cover critical functions
- [ ] Integration tests for new flows
- [ ] Manual testing completed

### 6. SmartLockers Specific Patterns

#### Cache-First Pattern (CRITICAL)
```php
// CORRECT - Update cache only on HTTP 2xx
if ($response['status_code'] === 200 && !empty($response['data'])) {
    api_store_result($clientName, 'key', $data, $ttl);
    return ['status' => 'success', 'source' => 'api'];
} else {
    $cached = api_get_stored_data($clientName, 'key');
    return $cached ? ['status' => 'cached'] : ['status' => 'error'];
}

// WRONG - Updating cache without status check
api_store_result($clientName, 'key', $response['data'], $ttl);
```

#### Function Prefixes
| Prefix | Layer | Example |
|--------|-------|---------|
| `client_` | Client logic | `client_onet_process_reservation()` |
| `api_` | External API calls | `api_beds24_get_bookings()` |
| `provider_` | Provider abstraction | `provider_get_reservations()` |
| `db_` | Database operations | `db_select()`, `db_insert()` |
| `auth_` | Authentication | `auth_validate_jwt()` |

#### Manual Require
```php
// CORRECT - Explicit require_once
require_once __DIR__ . '/../apis/beds24_functions.php';

// WRONG - Assuming autoload
use App\Apis\Beds24Functions;  // NO PSR-4 in this project
```

#### UUID for Lockers (NOT numeric ID)
```php
// CORRECT - Use uuid
$locker = db_select_one('lockers', ['uuid' => $lockerUuid]);

// WRONG - Sync API doesn't expose numeric ID
$locker = db_select_one('lockers', ['id' => $lockerId]);
```

#### PHPDoc Required
```php
/**
 * Description of what the function does
 *
 * @param string $clientName Client identifier
 * @param array $config Configuration array
 * @return array Result with keys: status, data, source
 * @throws Exception When API call fails
 */
function api_example_call(string $clientName, array $config): array
```

## Severity Levels

### 🔴 Critical Issues
Must be fixed before merge:
- Security vulnerabilities
- Data integrity risks
- Cache-first pattern violations
- Missing error handling on critical paths
- Breaking changes

### 🟡 Warnings
Should be fixed, can be tracked:
- Missing PHPDoc
- Code style violations
- Performance concerns
- Incomplete validation
- Missing tests

### 🟢 Suggestions
Nice to have, optional:
- Code organization improvements
- Better variable names
- Additional comments
- Refactoring opportunities

## Common Issues to Watch

### 1. Cache Pattern Violations
```php
// ISSUE: No fallback on error
$data = api_get_data();
return $data;  // What if API fails?

// FIX: Add fallback
$data = api_get_data();
if ($data['status'] === 'error') {
    return api_get_stored_data($clientName, 'key');
}
```

### 2. Missing Sanitization
```php
// ISSUE: Direct use of input
$clientName = $_GET['client'];

// FIX: Sanitize
$clientName = sanitize_client_name($_GET['client'] ?? '');
```

### 3. Hardcoded Values
```php
// ISSUE: Magic numbers
if ($ttl > 3600) { ... }

// FIX: Use constants or config
if ($ttl > DEFAULT_CACHE_TTL) { ... }
```

### 4. Inconsistent Returns
```php
// ISSUE: Mixed return types
function getData() {
    if ($error) return false;
    return $data;  // Array expected
}

// FIX: Consistent structure
function getData(): array {
    if ($error) return ['status' => 'error', 'data' => []];
    return ['status' => 'success', 'data' => $data];
}
```

## Decision Criteria

| Condition | Decision |
|-----------|----------|
| 0 critical, 0 warnings | ✅ Approve |
| 0 critical, < 5 warnings | ✅ Approve with comments |
| 0 critical, >= 5 warnings | ⚠️ Request minor changes |
| 1+ critical issues | ❌ Request changes |
| Security vulnerability | ❌ Block merge |
