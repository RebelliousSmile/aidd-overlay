---
name: api-integration-assistant
description: |
  Use this skill when the user wants to integrate a new external API,
  create API functions, or needs guidance on API integration patterns.
  Triggers: "integrate API", "add API", "new API integration",
  "connect to API", "API setup", "create API"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
argument-hint: "[api_name]"
---

# API Integration Assistant

Guide users through integrating new external APIs into SmartLockers following cache-first resilience patterns.

## Workflow

### Step 0: Gather Information

Ask user the questionnaire (see `reference.md` for full questions):

```markdown
**Phase 1/3: Basic Info**
1. API name (for file naming)
2. Client(s) using this API
3. Official documentation URL

**Phase 2/3: Authentication (CRITICAL)**
4. Auth flow type: Simple (A/B) or Multi-step (C/D)?
5. Auth headers format
6. Token expiration and refresh

**Phase 3/3: Endpoints**
7. Base URL
8. Main endpoints to integrate
9. Rate limits and TTL
```

### Step 1: Validate API Name

```bash
api_name=$(echo "$API_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g')

if [ -f "code/apis/${api_name}_functions.php" ]; then
    echo "API ${api_name} already exists"
fi
```

### Step 2: Generate API Functions File

Create `code/apis/${api_name}_functions.php` using template from `templates/api-functions.php`.

Key functions to generate:
- `api_${api_name}_authenticate()` - Auth handling
- `api_${api_name}_get_resource()` - Cache-first GET pattern
- `api_${api_name}_create_resource()` - API-first POST
- `api_${api_name}_update_resource()` - API-first PUT
- `api_${api_name}_delete_resource()` - API-first DELETE

### Step 2.5: Multi-Step Auth (If Needed)

**IF** auth flow = Multi-step custom (like Beds24):
- Create `code/scripts/setup_${api_name}_auth.php`
- Create `.temp/credentials/${api_name}_invitation_token.txt` template
- Reference: `code/scripts/setup_beds24_auth.php`

### Step 3: Generate Configuration

Display config template for `code/clients/config/${client}.cfg`.
See `templates/config.ini` for format.

### Step 4: Update Client Authorization

Guide user to add API in `client_${client}_get_required_apis()`.

### Step 5: Generate Contract Tests

Create `code/tests/contracts/test_api_${api_name}.php` using `templates/test-contract.php`.

### Step 6: Generate Documentation

Create `documentation/notebooks/api/${api_name}.md` using `templates/documentation.md`.

### Step 7: Validate

```bash
# Run validation script
.claude/skills/api-integration-assistant/scripts/validate-api.sh ${api_name}
```

### Step 8: Final Report

Display summary with:
- Files created
- Files to modify
- Configuration needed
- Next steps

## Critical Patterns

### Cache-First (GET Operations)
```php
return api_resilient_call(
    clientName: $clientName,
    apiName: '${api_name}',
    cacheKey: 'resource_' . md5(json_encode($params)),
    apiCall: function() { /* ... */ },
    ttl: 3600
);
```

### API-First (Mutations)
```php
// POST, PUT, DELETE: No cache, call API directly
$response = http_post($url, ['headers' => $headers, 'body' => $data]);
```

### Return Format
```php
[
    'status' => 'success|degraded|error',
    'source' => 'api|cache|stale_cache',
    'data' => $data,
    'fresh' => true|false
]
```

## Files Reference

| File | Purpose |
|------|---------|
| `reference.md` | Auth patterns, config templates, questionnaire |
| `templates/api-functions.php` | PHP function template |
| `templates/test-contract.php` | Contract test template |
| `templates/config.ini` | Configuration template |
| `templates/documentation.md` | API documentation template |
| `examples/beds24-oauth2.md` | Multi-step auth example |
| `scripts/validate-api.sh` | Validation script |

## Success Criteria

- [ ] API functions file created with cache-first pattern
- [ ] PHPDoc complete on all functions
- [ ] Configuration template provided
- [ ] Client authorized (get_required_apis updated)
- [ ] Contract tests created and passing
- [ ] Documentation created
- [ ] PHPStan level 6: 0 errors
