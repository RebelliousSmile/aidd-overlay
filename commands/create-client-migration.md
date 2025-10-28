# Create Client Migration

Generate a complete client setup including:
- Database migration for API cache table
- Client routes file with process and entity routes
- Stub implementations ready to customize

## Usage

```
/create-client-migration
```

The command will prompt for:
1. **Client name** (lowercase, e.g., "acme")
2. **APIs used** (comma-separated, e.g., "MSExchange,Pilotphone")
3. **Entities managed** (comma-separated, e.g., "reservations,vehicles,agents")

## What Gets Created

### 1. Migration File
`code/src/migrations/{timestamp}_create_{client}_api_cache.php`

Creates the `{client}_api_cache` table with:
- Stores API response data with expiration
- Indexed for optimal cache key lookups
- Supports cache invalidation strategies

### 2. Client Routes File
`code/clients/{client}_functions.php`

Includes:
- **Standard functions**: `get_name()`, `get_specific_data()`, `get_required_apis()`, etc.
- **Route definitions**: `get_custom_routes()` with all routes
- **Route handler**: `client_{client}_handle()` with routing logic
- **Route implementations**: Stub functions for all routes

### 3. Routes Generated

#### Always Created
- **`process-{client}`** (POST) - Synchronization route to update cache from APIs
  - Parameter: `force_refresh` (boolean, optional)
  - Forces cache refresh when called
  - Intended for cron jobs and automated processes

#### Per Entity
For each entity specified, creates:

- **`{entity}`** (GET) - Get all entities
  - Parameters: `limit`, `offset` for pagination
  - Returns array of entities from cache

- **`{entity}/{id}`** (GET) - Get single entity by ID
  - Parameter: `id` (required)
  - Returns single entity from cache

## Example

### Interactive Session

```bash
/create-client-migration

Enter the client name (lowercase, e.g., 'newclient'): acme

Which APIs does this client use? (comma-separated): MSExchange,Pilotphone

Which entities does this client manage? (comma-separated): reservations,vehicles
```

### Result

**Migration created:**
- `code/src/migrations/20251006120000_create_acme_api_cache.php`

**Routes file created:**
- `code/clients/acme_functions.php`

**Routes available:**
- `POST /api/acme/process-acme` - Update cache from APIs
- `GET /api/acme/reservations` - Get all reservations
- `GET /api/acme/reservations/{id}` - Get reservation by ID
- `GET /api/acme/vehicles` - Get all vehicles
- `GET /api/acme/vehicles/{id}` - Get vehicle by ID

## Running the Migration

After generation, run the migration:
```bash
php code/scripts/migrate.php up
```

## Customizing Generated Code

The generated client file contains TODO comments marking where to add custom logic:

```php
// TODO: Implémenter la logique de synchronisation
// Exemple: $result = api_sync_data($clientName, $forceRefresh);

// TODO: Implémenter la récupération depuis le cache ou la base
// Exemple: $data = api_get_stored_data($clientName, 'reservations');
```

## Benefits

✅ **Complete scaffolding** - Full client setup in one command
✅ **Consistent structure** - Follows project conventions
✅ **Ready to customize** - TODO markers guide implementation
✅ **Route automation** - All CRUD routes pre-generated
✅ **Process route included** - Cache sync ready for cron

## See Also

- `/analyze-api-cache` - Analyze existing client data and propose consolidation tables
- `documentation/architecture/` - Architecture documentation
- `documentation/developpement/` - Development standards
