---
name: smartlockers-sync
description: Define data mapping and synchronization between external APIs and SmartLockers Sync API. Use when implementing client integrations, data transformations, or reservation processing.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch
---

# SmartLockers Sync Task - Data Mapping & Synchronization

Define comprehensive data mappings and transformations between external APIs and SmartLockers Sync API.

## Instructions

This skill helps you create a complete specification for synchronizing data from external APIs (MSExchange, Pilotphone, Guesty, etc.) to SmartLockers.

### What to do:

1. **Gather client context**:
   - Client name (Halpades, ONET, CosyHosting, etc.)
   - External APIs used
   - Business rules specific to client

2. **Analyze source data**:
   - Read API documentation
   - Examine data structures
   - Identify available fields

3. **Define mappings** using the template below

4. **Verify against database schema**:
   - Check `documentation/architecture/database-schema-complete.md`
   - Ensure field types match

## SmartLockers Sync Template

```markdown
# Sync Task: [Client Name] - [Integration Name]

## Client Context

**Client:** [Client name]
**External APIs:** [APIs used: MSExchange, Pilotphone, Guesty, etc.]
**SmartLockers Enterprise:** [Enterprise name in SmartLockers]
**Sync Function:** `client_[client]_handle_process_[entity]()`

## Synchronization Objective

[Description of what data flows where]

Example: "Synchronize MSExchange reservations to SmartLockers to automatically create locker access codes for vehicle parking."

## Source Data (External API)

### Data Structure Received

**API:** [API name]
**Endpoint/Function:** `api_[provider]_[action]()`

```json
{
  "example_field": "value",
  "nested": {
    "field": "value"
  }
}
```

**Available Fields:**
- `field_name` (type) - Description and business meaning
- `field_name` (type) - Description and business meaning

### Client-Specific Business Rules

1. **Rule 1:**
   - Condition: [when this applies]
   - Transformation: [how to transform]
   - Example: For Halpades, license plate extracted from email (GG-585-VT@halpades.fr → GG-585-VT)

2. **Rule 2:**
   - Condition: [when this applies]
   - Transformation: [how to transform]
   - Example: [concrete example]

## SmartLockers Entity Mappings

### Entities to Create/Update

Select applicable entities:
- [ ] **Users** (utilisateurs)
- [ ] **Customers** (clients linked to enterprise)
- [ ] **Entreprises** (organizations)
- [ ] **Lockers** (locker units)
- [ ] **LockerAllocations** (locker assignments)
- [ ] **AccessCodes** (access codes)

### Mapping: User

**Sync Function:** `sync_create_user()` or `sync_upsert_user()`

| SmartLockers Field | Type | Required | Source (External API) | Transformation | Example |
|-------------------|------|----------|----------------------|----------------|---------|
| `Name` | string | ✅ | [source field] | [if any] | John Doe |
| `Phone` | string | ✅ | [source field] | International format without + | 33638056100 |
| `Email` | string | ✅ | [source field] | Lowercase | john@example.com |
| `CREATION` | datetime | Auto | | `date('Y-m-d H:i:s')` | 2025-01-15 10:30:00 |
| `MODIFICATION` | datetime | Auto | | `date('Y-m-d H:i:s')` | 2025-01-15 10:30:00 |

**Validation Rules:**
- Phone: Must be valid international format
- Email: Must be valid email format
- Name: Cannot be empty

### Mapping: Customer

**Sync Function:** `sync_create_customer()` or `sync_upsert_customer()`

| SmartLockers Field | Type | Required | Source | Transformation | Example |
|-------------------|------|----------|---------|----------------|---------|
| `user_id` | int | ✅ | | User ID from previous step | 123 |
| `entreprise_id` | int | ✅ | | `sync_find_entreprise_id('EnterpriseName')` | 45 |
| `info_user` | text | ❌ | | Additional tracking info | License: ABC-123 |
| `status` | string | ❌ | | Default: 'OK' | OK |
| `amount` | decimal | ❌ | | Default: 0.00 | 0.00 |

**Business Rules:**
- Enterprise ID: [How to determine enterprise]
- Info user: [What additional info to store]

### Mapping: Locker Allocation

**Sync Function:** `sync_create_locker_allocation()`

**CRITICAL: Use UUID for locker identification**
- Field `uuid` (VARCHAR 36) is the unique identifier
- Field `num` (INT) is the locker number (1, 2, 3...)
- Field `ext_ref_locker` (VARCHAR) is external business reference
- **NEVER use numeric `ID` in WHERE/UPDATE clauses**

| SmartLockers Field | Type | Required | Source | Transformation | Example |
|-------------------|------|----------|---------|----------------|---------|
| `entreprise_id` | int | ✅ | | Same as Customer | 45 |
| `locker_uuid` | string | ✅ | | `sync_find_available_locker($start, $end)` | abc-def-123 |
| `datetime_debut` | datetime | ✅ | [source] | ISO 8601 format | 2025-01-15 08:00:00 |
| `datetime_fin` | datetime | ✅ | [source] | ISO 8601 format | 2025-01-20 18:00:00 |
| `notes` | text | ❌ | | Traceability info | Booking ref: XYZ123 |

**Allocation Rules:**
- Locker selection: [How to choose locker: availability, location, size]
- Period calculation: [How to determine start/end dates]
- Notes: [What tracking info to include]

### Mapping: Access Code

**Sync Function:** `sync_generate_access_code()`

| Parameter | Type | Required | Source | Example |
|-----------|------|----------|---------|---------|
| `locker_uuid` | string | ✅ | Locker UUID from allocation | abc-def-123 |
| `customer_id` | int | ✅ | Customer ID from creation | 123 |

**Code Generation:**
- Code automatically generated by SmartLockers
- Communication: [How/when to send code to customer]

## Processing Flow

```
1. Fetch data from external API
   ↓
2. Validate and filter per client business rules
   ↓
3. Transform data (mapping)
   ↓
4. Create/Update User (sync_upsert_user)
   ↓
5. Create/Update Customer (sync_upsert_customer)
   ↓
6. Find available locker by UUID (sync_find_available_locker)
   ↓
7. Create locker allocation with UUID (sync_create_locker_allocation)
   ↓
8. Generate access code (sync_generate_access_code)
   ↓
9. Store result in cache/database
```

### Error Handling Strategy

**On failure:**
- [ ] **Full rollback** - Cancel all creations if any step fails
- [ ] **Partial rollback** - Cancel only last step
- [ ] **Continue** - Log error and continue with other items
- [ ] **Retry** - Retry X times with delay

**Scenarios:**
- User already exists: [Update / Ignore / Error]
- Customer already exists: [Update / Ignore / Error]
- No locker available: [Queue / Error / Notify]
- Incomplete source data: [Use defaults / Skip entry / Error]

### Data Validation

**Mandatory validations before sync:**
- [ ] Valid email format
- [ ] Valid phone format (international)
- [ ] Dates coherent (start < end)
- [ ] Enterprise exists in SmartLockers
- [ ] Required fields not empty
- [ ] Locker UUID valid (not numeric ID)

## Concrete Examples

### Example 1: Successful Case

**Source Data:**
```json
{
  "user_name": "John Doe",
  "user_email": "john@example.com",
  "user_phone": "+33638056100",
  "start_date": "2025-01-15T08:00:00",
  "end_date": "2025-01-20T18:00:00"
}
```

**Transformation:**
```php
$userData = [
    'Name' => 'John Doe',
    'Email' => 'john@example.com',
    'Phone' => '33638056100' // International format without +
];

$allocationData = [
    'datetime_debut' => '2025-01-15 08:00:00',
    'datetime_fin' => '2025-01-20 18:00:00'
];
```

**Result sent to SmartLockers:**
```php
[
    'user' => ['id' => 123, 'name' => 'John Doe'],
    'customer' => ['id' => 456, 'user_id' => 123],
    'allocation' => ['locker_uuid' => 'abc-def-123', 'customer_id' => 456]
]
```

### Example 2: Error Case

**Source Data:**
```json
{
  "user_name": "Jane Doe",
  "user_email": "invalid-email",
  "user_phone": "123"
}
```

**Problem:** Invalid email format
**Action:** Skip entry and log error

## Technical Implementation

### Files Involved

- **Client functions:** `code/clients/[client]_functions.php`
- **Route handler:** `client_[client]_handle_process_[entity]()`
- **Processor:** `code/src/services/[client]_[entity]_processor.php` (if needed)
- **Tests:** `code/tests/clients/[client]/test_sync_*.php`

### SmartLockers Sync Functions

```php
require_once __DIR__ . '/code/src/services/smartlockers_sync.php';

// Functions used:
- sync_upsert_user($userData)
- sync_upsert_customer($customerData)
- sync_find_entreprise_id($entrepriseName)
- sync_find_available_locker($startDate, $endDate) // Returns UUID
- sync_create_locker_allocation($allocationData) // Use UUID
- sync_generate_access_code($lockerUuid, $customerId)
```

### Cache Strategy

**What to cache:**
- [ ] Source data (external API)
- [ ] User mappings (email → user_id)
- [ ] Customer mappings
- [ ] Enterprise IDs

**TTL recommendations:**
- Source data: [e.g., 1 hour]
- User/Customer mappings: [e.g., 24 hours]
- Enterprise IDs: [e.g., never expire]

**Cache-first pattern:**
```php
if ($response['status_code'] === 200 && !empty($response['data'])) {
    api_store_result($clientName, 'data_key', $processedData, $ttl);
    return ['status' => 'success', 'source' => 'api'];
} else {
    $cachedData = api_get_stored_data($clientName, 'data_key');
    return $cachedData ? ['status' => 'cached', 'source' => 'cache'] : ['status' => 'error'];
}
```

## Testing

### Test Scenarios

- [ ] **Complete creation** - User + Customer + Allocation + Code
- [ ] **Existing user** - Upsert without duplicate
- [ ] **Existing customer** - Upsert without duplicate
- [ ] **No locker available** - Error handling
- [ ] **Invalid data** - Validation and skip
- [ ] **Rollback** - Cancellation on error
- [ ] **Performance** - Process 100+ items
- [ ] **UUID validation** - Reject numeric IDs

### Test Data

Create fixtures:
```php
// tests/fixtures/[client]_[entity].json
```

## Documentation

### Document:

- [ ] Client business rules in `documentation/clients/[client].md`
- [ ] Mapping examples in this task
- [ ] Error codes and resolutions
- [ ] Debugging guide for this client

## Acceptance Criteria

- [ ] All source data correctly mapped
- [ ] Client business rules respected
- [ ] Robust error handling
- [ ] Validations in place
- [ ] Tests pass at 100%
- [ ] Acceptable performance (< Xs per item)
- [ ] Complete documentation
- [ ] Code reviewed
- [ ] PHPStan niveau 6 passes
- [ ] UUID used for locker identification (never numeric ID)

## Important Notes

**Database Infrastructure:**
- MariaDB 10.11.14
- JSON type (not JSONB)
- Lockers table: `uuid` (VARCHAR 36), `num` (INT), `ext_ref_locker` (VARCHAR)
- **API Sync exposes UUID only, not numeric ID**

**Critical Rules:**
- Cache-first pattern mandatory
- Bearer token auth only
- Verify schema in `documentation/architecture/database-schema-complete.md`
- Use UUID in WHERE/UPDATE/PUTUPDATE for lockers
```

---

**Date created:** [Auto-filled]
**Author:** [Auto-filled]
**Version:** 1.0
