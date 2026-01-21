# Example: Beds24 Multi-Step OAuth2 Integration

> Real example of integrating Beds24 API with multi-step authentication flow.

## Context

- **Client**: LockAndChill
- **Auth Model**: owner (distributed - one OAuth2 per property owner)
- **Auth Flow**: Multi-step custom (invitation → setup → refresh → access)

## Authentication Flow

```
1. Manual: Owner generates invitation code in Beds24 UI
       ↓
2. Setup: GET /authentication/setup (header: invitationCode)
   → Returns: token (24h) + refreshToken (30 days)
       ↓
3. Access: Use token for API calls
       ↓
4. Refresh: GET /authentication/token (header: refreshToken)
   → Returns: new token (24h)
```

## Files Created

### API Functions: `code/apis/beds24_functions.php`

```php
/**
 * Exchange invitation code for tokens (one-time setup)
 */
function api_beds24_setup_authentication(string $invitationCode): array
{
    $response = http_get('https://beds24.com/api/v2/authentication/setup', [
        'headers' => ['code' => $invitationCode]
    ]);

    if ($response['status'] !== 200) {
        throw new Exception("Beds24 setup failed: " . $response['body']);
    }

    return json_decode($response['body'], true);
    // Returns: ['token' => '...', 'refreshToken' => '...', 'expiresIn' => 86400]
}

/**
 * Refresh access token using refresh token
 */
function api_beds24_refresh_token(string $refreshToken): array
{
    $response = http_get('https://beds24.com/api/v2/authentication/token', [
        'headers' => ['refreshToken' => $refreshToken]
    ]);

    if ($response['status'] !== 200) {
        throw new Exception("Beds24 refresh failed: " . $response['body']);
    }

    return json_decode($response['body'], true);
}

/**
 * Get properties with cache-first pattern
 */
function api_beds24_get_properties(array $config, int $ownerId): array
{
    return api_resilient_call(
        clientName: 'lockandchill',
        apiName: 'beds24',
        cacheKey: "properties_owner_{$ownerId}",
        apiCall: function() use ($config, $ownerId) {
            // Get fresh token (auto-refresh if needed)
            $token = api_beds24_get_valid_token($config, $ownerId);

            $response = http_get('https://beds24.com/api/v2/properties', [
                'headers' => ['token' => $token]
            ]);

            return [
                'status_code' => $response['status'],
                'data' => json_decode($response['body'], true)
            ];
        },
        ttl: 3600
    );
}
```

### Setup Script: `code/scripts/setup_beds24_auth.php`

```php
#!/usr/bin/env php
<?php
/**
 * Setup Beds24 OAuth2 Authentication
 *
 * Usage: php code/scripts/setup_beds24_auth.php <owner_id>
 */

require_once __DIR__ . '/../src/services/database.php';
require_once __DIR__ . '/../apis/beds24_functions.php';

$ownerId = $argv[1] ?? null;
if (!$ownerId) {
    echo "Usage: php {$argv[0]} <owner_id>\n";
    exit(1);
}

// Read invitation code from temp file
$codeFile = ".temp/credentials/beds24_invitation_{$ownerId}.txt";
if (!file_exists($codeFile)) {
    echo "❌ Invitation code file not found: {$codeFile}\n";
    echo "   Create file with invitation code from Beds24 UI\n";
    exit(1);
}

$invitationCode = trim(file_get_contents($codeFile));

try {
    echo "🔑 Exchanging invitation code for tokens...\n";
    $tokens = api_beds24_setup_authentication($invitationCode);

    // Store in owner record
    db_update('lockandchill_owners', [
        'api_access_token' => $tokens['token'],
        'api_refresh_token' => $tokens['refreshToken'],
        'api_token_expires_at' => date('Y-m-d H:i:s', time() + $tokens['expiresIn'])
    ], ['id' => $ownerId]);

    echo "✅ Tokens stored for owner {$ownerId}\n";
    echo "   Access token expires: " . date('Y-m-d H:i:s', time() + $tokens['expiresIn']) . "\n";

    // Delete invitation code file (single use)
    unlink($codeFile);
    echo "🗑️ Invitation code file deleted (single use)\n";

    // Test API access
    echo "🧪 Testing API access...\n";
    $result = api_beds24_get_properties(['owner_id' => $ownerId], $ownerId);

    if ($result['status'] === 'success') {
        $count = count($result['data']['properties'] ?? []);
        echo "✅ API test successful: {$count} properties found\n";
    } else {
        echo "⚠️ API returned: {$result['status']}\n";
    }

} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
    exit(1);
}
```

### Configuration: `code/clients/config/lockandchill.cfg`

```ini
[Beds24]
# Auth model = owner (tokens stored per owner in DB, not in config)
api_beds24_auth_model=owner
api_beds24_base_url=https://beds24.com/api/v2

# Endpoints
api_beds24_properties_endpoint=/properties
api_beds24_bookings_endpoint=/bookings

# TTL Cache
ttl_beds24_properties=3600
ttl_beds24_bookings=1800
```

### Owner Table Schema

```sql
CREATE TABLE lockandchill_owners (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    api_access_token TEXT,
    api_refresh_token TEXT,
    api_token_expires_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Key Patterns

### 1. Token Auto-Refresh
```php
function api_beds24_get_valid_token(array $config, int $ownerId): string
{
    $owner = db_get_one('lockandchill_owners', ['id' => $ownerId]);

    // Check if token expired or expiring soon (5 min buffer)
    $expiresAt = strtotime($owner['api_token_expires_at']);
    if ($expiresAt < time() + 300) {
        // Refresh token
        $tokens = api_beds24_refresh_token($owner['api_refresh_token']);

        // Update in DB
        db_update('lockandchill_owners', [
            'api_access_token' => $tokens['token'],
            'api_token_expires_at' => date('Y-m-d H:i:s', time() + $tokens['expiresIn'])
        ], ['id' => $ownerId]);

        return $tokens['token'];
    }

    return $owner['api_access_token'];
}
```

### 2. Custom Header (Beds24 uses `token:` not `Authorization:`)
```php
$headers = [
    'token' => $accessToken,  // NOT 'Authorization: Bearer ...'
    'Accept' => 'application/json'
];
```

### 3. Invitation Code Handling
- **Single use**: Code is consumed on first setup
- **Store in temp file**: `.temp/credentials/beds24_invitation_{owner}.txt`
- **Delete after use**: Security best practice

## Lessons Learned

1. **Read API docs carefully** - Beds24 uses non-standard headers
2. **Handle token refresh proactively** - Add buffer before expiration
3. **Per-owner tokens require DB storage** - Not config files
4. **Invitation codes are fragile** - Test with curl first before PHP
