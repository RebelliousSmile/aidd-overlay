# Documentation Sync Reference

Detailed mappings and patterns for documentation synchronization.

## Code → Documentation Mapping

### Client Files
| Code File | Documentation Target |
|-----------|---------------------|
| `code/clients/onet_functions.php` | `documentation/notebooks/client/onet.md` |
| `code/clients/cosyhosting_functions.php` | `documentation/notebooks/client/cosyhosting.md` |
| `code/clients/halpades_functions.php` | `documentation/notebooks/client/halpades.md` |
| `code/clients/lockandchill_functions.php` | `documentation/notebooks/client/lockandchill.md` |

### API Files
| Code File | Documentation Target |
|-----------|---------------------|
| `code/apis/sync_functions.php` | `documentation/notebooks/api/sync.md` |
| `code/apis/guesty_functions.php` | `documentation/notebooks/api/guesty.md` |
| `code/apis/beds24_functions.php` | `documentation/notebooks/api/beds24.md` |
| `code/apis/pilotphone_functions.php` | `documentation/notebooks/api/pilotphone.md` |
| `code/apis/planet_functions.php` | `documentation/notebooks/api/planet.md` |
| `code/apis/msexchange_functions.php` | `documentation/notebooks/api/msexchange.md` |

### Database Files
| Code File | Documentation Target |
|-----------|---------------------|
| `code/src/services/database.php` | `documentation/notebooks/architecture/database-schema-complete.md` |
| `code/src/migrations/*.php` | `documentation/notebooks/architecture/database/*.md` |

### Architecture Files
| Code File | Documentation Target |
|-----------|---------------------|
| `code/src/services/auth.php` | `documentation/memory-bank/guides/authentification.md` |
| `code/routes/*.php` | `documentation/notebooks/api/README.md` |

## 8 Documentation Directories

### 1. memory-bank/ (Primary - 80-90% of needs)
```
memory-bank/
├── core/           # Essential docs (always loaded)
│   ├── quick-start.md
│   ├── architecture-essentials.md
│   ├── conventions-dev.md
│   ├── database-schema-quick.md
│   └── business-rules.md
└── guides/         # Specific use cases
    ├── gestion-clients.md
    ├── reservation-patterns.md
    ├── authentification.md
    └── database-migrations.md
```

### 2. notebooks/ (Deep Analysis)
```
notebooks/
├── api/            # External API documentation
├── architecture/   # System design, patterns
├── developpement/  # Development guides
└── fonctionnel/    # Business logic docs
```

### 3. guides/ (Step-by-step)
Tutorials and workflows for specific tasks.

### 4. diagrams/ (Visualizations)
Architecture diagrams, flow charts, data models.

### 5. tasks/ (Task Definitions)
Structured task documents with DoD.

### 6. reviews/ (Code Reviews)
Code review reports with findings.

### 7. reports/ (Technical Reports)
Conformity matrices, gap analyses.

### 8. wireframes/ (UI/UX)
Mockups and design documents.

## Function Documentation Format

### PHPDoc Standard
```php
/**
 * Brief description of what the function does
 *
 * Detailed explanation if needed, including:
 * - Important behaviors
 * - Side effects
 * - Cache patterns used
 *
 * @param string $clientName Client identifier (e.g., 'cosyhosting')
 * @param array $config Configuration array with keys:
 *   - api_key: string API key
 *   - timeout: int Timeout in seconds
 * @return array Result with structure:
 *   - status: string 'success'|'error'|'cached'
 *   - data: array Returned data
 *   - source: string 'api'|'cache'
 * @throws Exception When API call fails and no cache available
 *
 * @example
 * $result = api_example_call('cosyhosting', ['timeout' => 30]);
 * if ($result['status'] === 'success') {
 *     // Process data
 * }
 */
```

### Markdown API Documentation
```markdown
### `api_function_name($param1, $param2, $config)`

**Description**: What this function does

**Parameters**:
- `$param1` (string): Description
- `$param2` (array): Description
- `$config` (array): Client configuration

**Returns**: array with structure:
```php
[
    'status' => 'success|error|cached',
    'data' => [...],
    'source' => 'api|cache'
]
```

**Example**:
```php
$result = api_function_name($data, 'cosyhosting', $config);
```

**Notes**:
- Uses cache-first pattern
- Falls back to cache on API error
```

## Sync Report Format

```markdown
# Documentation Sync Report

**Date**: YYYY-MM-DD
**Changes analyzed**: X files
**Documents updated**: Y files

## Changes Detected

### PHP Code Modified
- `code/apis/beds24_functions.php` (+45 lines, 2 new functions)
- `code/clients/lockandchill_functions.php` (+12 lines, modified)

### Documentation Updates Applied
- ✅ `notebooks/api/beds24.md` - Added 2 function docs
- ✅ `memory-bank/guides/reservation-patterns.md` - Updated example
- ⏭️ `notebooks/client/lockandchill.md` - No changes needed

## PHPDoc Status
- Functions with PHPDoc: 45/48 (94%)
- Missing PHPDoc: 3 functions (listed below)

## Next Steps
1. Add PHPDoc to: `client_lockandchill_helper()` (line 234)
2. Run `composer phpstan`
3. Commit: "docs: sync after beds24 integration"
```

## Token Estimation

| File Type | Tokens per KB |
|-----------|--------------|
| Markdown | ~250 tokens/KB |
| PHP code | ~300 tokens/KB |
| JSON | ~350 tokens/KB |

### Size Guidelines
- Quick reference: < 2k tokens (~8 KB)
- Memory-bank core file: < 5k tokens (~20 KB)
- Notebook deep dive: < 10k tokens (~40 KB)

## Cleanup Criteria

### Files to Archive (> 30 days old)
- `documentation/reviews/review-*.md` - Completed reviews
- `documentation/tasks/*.md` - Finished tasks (check DoD)

### Files to Delete
- `CLAUDE.md.backup-*` - Git keeps history
- `*.tmp`, `*.bak` - Temporary files
- Empty directories

### Never Delete
- `memory-bank/core/*` - Essential docs
- Files referenced in CLAUDE.md
- Files modified in last 30 days
