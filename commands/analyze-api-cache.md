# Analyze API Cache

Analyzes API routes queried and data cached for a client, then proposes database consolidation schema with test tables.

## Usage

```
/analyze-api-cache <client_name>
```

**Parameters:**
- `client_name` (required): Client name in lowercase (ex: "halpades", "onet", "cosyhosting")

## Features

The command performs the following operations:

### 1. Code Analysis
- Scans `code/clients/{client}_functions.php` and `code/apis/*_functions.php` files
- Identifies all `api_store_result()` calls to discover cache keys
- Extracts data variables and associated TTLs

### 2. Database Analysis
- Verifies existence of `{client}_api_cache` table
- Retrieves existing cache entries (max 100 most recent)
- Analyzes JSON structure of stored data

### 3. Proposal Generation
- Proposes consolidation tables based on detected patterns:
  - `{client}_reservations`: Reservations
  - `{client}_vehicles`: Vehicles
  - `{client}_emails`: Emails
  - `{client}_contacts`: Contacts
  - `{client}_materiels`: Materials
  - `{client}_agents`: Agents
  - `{client}_assignations`: Assignments
  - `{client}_guests`: Guests
  - `{client}_listings`: Properties

### 4. Duplicate Test Tables
- For each proposed table, automatically generates a `test_{table_name}` table
- Identical structure to allow testing without impacting production data

### 5. Migration File
- Creates migration file in `code/src/migrations/`
- Contains CREATE TABLE for main and test tables
- Contains DROP TABLE for rollback (down)
- Ready to execute with `php code/scripts/migrate.php up`

## Output

The command generates:

1. **Analysis report**:
   - List of discovered cache keys
   - Analyzed data structures
   - Proposed tables with their SQL

2. **Migration file**:
   - `code/src/migrations/{timestamp}_consolidate_{client}_data.php`
   - Main tables + test_ tables
   - up() and down() functions

## Example

### Analyze cache for Halpades

```
/analyze-api-cache halpades
```

This command will:
1. Analyze `code/clients/halpades_functions.php`
2. Analyze `code/apis/msexchange_functions.php` (used by Halpades)
3. Read `halpades_api_cache` table
4. Propose tables like:
   - `halpades_reservations` + `test_halpades_reservations`
   - `halpades_vehicles` + `test_halpades_vehicles`
   - `halpades_emails` + `test_halpades_emails`
5. Create migration `code/src/migrations/20251006120000_consolidate_halpades_data.php`

### Execute Migration

After generation:
```bash
php code/scripts/migrate.php up
```

## Proposed Table Structure

Each consolidation table contains:

### Common Fields
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `external_id`: VARCHAR(255) NOT NULL UNIQUE (external API ID)
- `data`: LONGTEXT NOT NULL (complete JSON data)
- `created_at`: DATETIME NOT NULL
- `updated_at`: DATETIME NOT NULL
- `synced_at`: DATETIME DEFAULT NULL

### Specific Fields by Type

**Reservations:**
- `start_date`, `end_date`, `status`, `customer_email`

**Vehicles:**
- `plate_number`, `model`, `status`

**Agents:**
- `nom`, `prenom`, `email`, `status`

## Use Cases

### 1. New Client
```bash
# First create cache table
/create-client-migration newclient
php code/scripts/migrate.php up

# Analyze and propose consolidation
/analyze-api-cache newclient
php code/scripts/migrate.php up
```

### 2. Existing Client
```bash
# Analyze existing cache data
/analyze-api-cache onet

# Review proposals if necessary
# Then execute migration
php code/scripts/migrate.php up
```

### 3. Testing
```bash
# test_ tables are created automatically
# Use in tests:
php tests/clients/halpades/test_consolidation.php
```

## Important Notes

- ✅ `test_*` tables created automatically
- ✅ Identical structure to production tables
- ✅ Allows testing without risk to real data
- ⚠️ Verify proposals before executing migration
- ⚠️ Adapt specific fields according to business needs

## Limitations

- Analysis limited to last 100 cache entries
- Automatic detection based on name patterns
- Generic structures to adapt to specific needs
- Does not delete old cache data

## See Also

- `/create-client-migration`: Create initial cache table
- `code/scripts/migrate.php`: Execute migrations
- `documentation/architecture/database-schema-complete.md`: Complete schema
