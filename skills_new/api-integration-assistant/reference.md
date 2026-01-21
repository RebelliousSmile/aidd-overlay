# API Integration Assistant - Reference

## Information Gathering Questionnaire

### Phase 1/3: Basic Information

1. **API Name**: [For file naming: api_<name>_functions.php]
2. **Client(s) using this API**: [onet, cosyhosting, lockandchill, other...]
3. **API Category**:
   - [ ] PMS (Property Management System - Beds24, Guesty, etc.)
   - [ ] Payment Gateway (Stripe, PayPal, etc.)
   - [ ] Email/SMS Service (Mailgun, SendGrid, Twilio)
   - [ ] CRM/Marketing
   - [ ] Other (specify)
4. **Official documentation**: [URL]
5. **Response format**: [JSON, XML, other]

### Phase 2/3: Authentication (CRITICAL)

6. **Authentication flow**:
   - [ ] A. Simple (static token, 1 step)
   - [ ] B. OAuth2 standard (client credentials, 2 steps)
   - [ ] C. Multi-step custom (invitation → refresh → access like Beds24)
   - [ ] D. Other (describe details)

**If A or B (simple flow)**:
7a. **Authentication type**:
   - [ ] Bearer Token static
   - [ ] API Key (header or query)
   - [ ] OAuth2 Client Credentials
   - [ ] Basic Auth

**If C or D (multi-step flow)**:
7b. **Describe complete flow**:
   Example Beds24:
   - Step 1: Generate invitation code (manual in UI)
   - Step 2: GET /authentication/setup (header: code) → token + refreshToken
   - Step 3: GET /authentication/token (header: refreshToken) → new token

8. **Authentication headers**:
   - [ ] A. Standard: `Authorization: Bearer {token}`
   - [ ] B. API Key: `X-API-Key: {key}`
   - [ ] C. Custom (specify): [ex: `token: {value}` for Beds24]

9. **Token management**:
   - Access token expires? [yes/no]
   - If yes, duration: [ex: 24h]
   - Refresh token available? [yes/no]
   - If yes, refresh validity: [ex: 30 days]

10. **Scopes/Permissions**:
    - Requires scope selection during initial setup? [yes/no]
    - If yes, required scopes list: [ex: read:bookings, write:properties]

### Phase 3/3: Endpoint Configuration

11. **Base URL**: [ex: https://api.example.com/v1]
12. **URL pattern**:
    - [ ] A. https://api.{service}.com/{version}
    - [ ] B. https://{service}.com/api/{version} (ex: Beds24)
    - [ ] C. Other (specify)
13. **Main endpoints**: [list endpoints to integrate]
14. **Test/validation endpoint**:
    - URL: [ex: GET /properties or GET /ping]
    - Expected response: [ex: HTTP 200 + JSON array]
15. **Rate limits**: [ex: 100 req/min, 1000 req/hour]
16. **Recommended cache TTL**: [ex: 30min for reservations, 1h for config]

---

## Authentication Patterns

### Bearer Token (Static)
```php
function api_${api_name}_authenticate(array $config): array
{
    return [
        'access_token' => $config['bearer_token'] ?? '',
        'token_type' => 'Bearer',
        'expires_in' => 86400
    ];
}
```

**Config**:
```ini
api_${api_name}_auth_type=bearer_token
api_${api_name}_bearer_token=**TODO**
```

### API Key
```php
function api_${api_name}_authenticate(array $config): array
{
    return [
        'access_token' => $config['api_key'] ?? '',
        'token_type' => 'ApiKey',
        'expires_in' => 86400
    ];
}
```

**Config**:
```ini
api_${api_name}_auth_type=api_key
api_${api_name}_api_key=**TODO**
```

### OAuth2 Client Credentials
```php
function api_${api_name}_authenticate_oauth2(array $config): array
{
    $tokenUrl = $config['token_url'] ?? $config['base_url'] . '/oauth/token';

    $response = http_post($tokenUrl, [
        'headers' => ['Content-Type' => 'application/x-www-form-urlencoded'],
        'body' => http_build_query([
            'grant_type' => 'client_credentials',
            'client_id' => $config['client_id'] ?? '',
            'client_secret' => $config['client_secret'] ?? ''
        ]),
        'timeout' => 30
    ]);

    if ($response['status'] !== 200) {
        throw new Exception("OAuth2 auth failed: " . $response['body']);
    }

    $data = json_decode($response['body'], true);
    return [
        'access_token' => $data['access_token'] ?? '',
        'token_type' => $data['token_type'] ?? 'Bearer',
        'expires_in' => $data['expires_in'] ?? 3600
    ];
}
```

**Config**:
```ini
api_${api_name}_auth_type=oauth2
api_${api_name}_client_id=**TODO**
api_${api_name}_client_secret=**TODO**
api_${api_name}_token_url=https://api.example.com/oauth/token
```

### Basic Auth
```php
function api_${api_name}_authenticate(array $config): array
{
    $credentials = base64_encode(
        ($config['username'] ?? '') . ':' . ($config['password'] ?? '')
    );
    return [
        'access_token' => $credentials,
        'token_type' => 'Basic',
        'expires_in' => 86400
    ];
}
```

**Config**:
```ini
api_${api_name}_auth_type=basic_auth
api_${api_name}_username=**TODO**
api_${api_name}_password=**TODO**
```

### Multi-Step (Beds24 Style)

Requires setup script. See `examples/beds24-oauth2.md`.

---

## Header Patterns by Auth Type

```php
$headers = [
    'Accept' => 'application/json',
    'Content-Type' => 'application/json'
];

// Add auth header based on type
switch ($auth['token_type']) {
    case 'Bearer':
        $headers['Authorization'] = 'Bearer ' . $auth['access_token'];
        break;
    case 'ApiKey':
        $headers['X-API-Key'] = $auth['access_token'];
        break;
    case 'Basic':
        $headers['Authorization'] = 'Basic ' . $auth['access_token'];
        break;
    case 'Custom':
        // API-specific header (e.g., Beds24 uses 'token:')
        $headers['token'] = $auth['access_token'];
        break;
}
```

---

## Critical Rules

### Security
1. **NEVER commit credentials in Git**
2. **ALWAYS validate config before API calls**
3. **ALWAYS sanitize user inputs**

### Quality
1. **ALWAYS use cache-first pattern** for GET operations
2. **NEVER cache mutations** (POST, PUT, DELETE)
3. **ALWAYS include PHPDoc** with parameters, return, exceptions, examples
4. **ALWAYS validate with PHPStan** level 6

### Architecture
1. **ALWAYS prefix functions** with `api_${name}_`
2. **ALWAYS update cache ONLY on HTTP 2xx**
3. **ALWAYS implement fallback to stale cache**
4. **ALWAYS return standardized response format**

---

## Response Format Standard

```php
[
    'status' => 'success|degraded|error',
    'source' => 'api|cache|stale_cache',
    'data' => $data,
    'fresh' => true|false
]
```

**Usage**:
```php
switch ($result['status']) {
    case 'success':
        // Fresh data from API
        $data = $result['data'];
        break;
    case 'degraded':
        // API down but cache available
        $data = $result['data'];
        // Show warning to user
        break;
    case 'error':
        // No API nor cache available
        error_log("No data available");
        break;
}
```

---

## Troubleshooting

### API Not Authorized for Client
**Cause**: Forgot to add in `get_required_apis()`
**Solution**: Edit `code/clients/${client}_functions.php`

### Missing Configuration
**Cause**: [API] section absent or incomplete in .cfg
**Solution**: Check all required keys (base_url, credentials)

### Tests Failing
**Cause**: Cache-first pattern not respected or invalid config
**Solution**:
1. Check `api_resilient_call()` used for GET operations
2. Check config contains all required keys
3. Run tests manually
