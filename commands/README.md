# Claude Slash Commands

This directory contains custom slash commands for the SmartLockers Client Manager project.

## Quick Reference

| Commande | Catégorie | Quand Utiliser |
|----------|-----------|----------------|
| `/update-docs` | 📝 Documentation | Après modif code |
| `/optimize-memory` | 📝 Documentation | Memory bank > 70% |
| `/clean-docs` | 📝 Documentation | Maintenance mensuelle |
| `/doc-quick-ref` | 📝 Documentation | Créer guide rapide |
| `/review-and-fix` | 🔍 Quality | Avant commit |
| `/fix-phpstan` | 🔍 Quality | Après PHPStan fails |
| `/task` | ⚙️ Workflow | Feature complète |
| `/create-client-migration` | ⚙️ Workflow | Nouveau client |
| `/check-memory` | 📊 Analysis | Quotidien |
| `/analyze-api-cache` | 📊 Analysis | Analyse cache |

## Available Commands

### `/create-client-migration`

Generates a database migration file to create the required API cache table for a new client.

### `/analyze-api-cache`

Analyzes API routes and cached data for a client, then proposes a database consolidation schema with test tables.

#### Usage

1. In Claude Code, type `/create-client-migration`
2. The command will execute the script `code/scripts/create_client_migration.php`
3. Follow the interactive prompt:
   - Enter the client name (lowercase, e.g., "newclient")

#### Direct Script Usage

You can also run the script directly from the command line:

```bash
php code/scripts/create_client_migration.php
```

Or make it executable and run:

```bash
./scripts/create_client_migration.php
```

#### What It Does

The command generates a migration file to create the `{client}_api_cache` table with:
- Complete CREATE TABLE statement with proper indexes and constraints
- Rollback functionality (down() function) to drop the table
- PHPDoc documentation
- Error handling

#### Table Created

**{client}_api_cache** - Standard API cache table
- Stores API response data with expiration
- Indexed for optimal cache key lookups
- Supports cache invalidation strategies

Note: Client-specific tables (guesty_*, pilotphone_*, etc.) are not automatically created. They should be created manually as needed based on the client's specific requirements.

#### After Generation

Once the migration is generated, run it with:

```bash
php code/scripts/migrate.php up
```

This will execute all pending migrations, including the newly created one.

#### Example

```bash
$ php code/scripts/create_client_migration.php
Enter the client name (lowercase, e.g., 'newclient'): acme

✓ Migration created successfully!

Client: acme
File: /path/to/src/migrations/20251003123456_create_acme_api_cache.php

Table to be created:
  - acme_api_cache

To run this migration, execute:
  php code/scripts/migrate.php up
```

## 📝 Documentation Commands

### `/update-docs [file_or_path]`

**Purpose:** Sync code → documentation automatically

**When:** After modifying code (part of Git workflow)

**What it does:**
- Detects code changes via `git diff`
- Extracts function signatures and PHPDoc
- Updates API documentation
- Updates database schemas
- Generates code examples

**Example:**
```bash
# After code modification
vim apis/sync.php
/update-docs apis/sync.php

# Result:
# - api/sync.md updated
# - PHPDoc added
# - Examples generated
```

**Note:** For memory bank optimization, use `/optimize-memory` instead.

---

### `/optimize-memory`

**Purpose:** Audit and optimize memory bank usage

**When:** Memory bank > 70% or periodic maintenance

**What it does:**
- Analyzes token usage
- Detects large files (> 5k tokens)
- Proposes consolidations
- Creates TL;DR summaries
- Organizes core vs contextual loading

**Delegates to:** `documentation-architect` agent

**Example:**
```bash
/optimize-memory

# Result:
# - Consolidated 3 sync files (gain 2.7k tokens)
# - Created quick refs (gain 8k tokens)
# - Memory: 75% → 58%
```

---

### `/clean-docs`

**Purpose:** Clean up temporary documentation files

**When:** Monthly maintenance or after major tasks

**What it does:**
- Scans for files > 30 days old not referenced
- Detects obsolete reviews, tasks, prompts
- Proposes archiving (conservative) or deletion (aggressive)
- Calculates token + disk savings

**Delegates to:** `documentation-architect` agent

**Example:**
```bash
/clean-docs

# Result:
# - 8 reviews archived (gain 12k tokens)
# - 12 CLAUDE.md backups deleted (gain 50k disk)
# - Active files: 25 → 3
```

---

### `/doc-quick-ref <component>`

**Purpose:** Create concise quick reference guide

**When:** Existing docs too verbose for quick lookup

**What it does:**
- Extracts essential info from complete docs
- Creates 3-tier structure (TL;DR / Quick / Deep)
- Optimizes for < 2k tokens
- Consults agents for decisions

**Delegates to:** `documentation-architect` agent

**Example:**
```bash
/doc-quick-ref circuit-breakers

# Result:
# - architecture/circuit-breakers-quick.md created
# - 1.8k tokens (vs 5.8k original)
# - Gain: -4k tokens
```

---

## 🔍 Code Quality Commands

### `/review-and-fix`

**Purpose:** Code review with automatic fixes

**When:** Before committing code

**What it does:**
- Reviews code against project checklist
- Identifies critical issues
- Proposes automatic fixes
- Validates against conventions

**Example:**
```bash
/review-and-fix

# Result:
# - 3 critical issues found
# - 5 auto-fixes proposed
# - Checklist: 8/10 passed
```

---

### `/fix-phpstan`

**Purpose:** Fix PHPStan errors iteratively

**When:** After `composer phpstan` shows errors

**What it does:**
- Analyzes PHPStan output
- Fixes errors one by one
- Documents common patterns
- Verifies fixes

**Example:**
```bash
composer phpstan  # 15 errors
/fix-phpstan

# Iteratively fixes until:
composer phpstan  # 0 errors ✅
```

---

## ⚙️ Workflow Commands

### `/task <description>`

**Purpose:** Execute complete task with tests and commit

**When:** Implementing new feature or fix

**What it does:**
- Plans implementation
- Writes code
- Runs tests
- Creates commit

**Example:**
```bash
/task "Implement JWT refresh endpoint"

# Result:
# - Code implemented
# - Tests passing
# - Committed with proper message
```

---

## Command Descriptions

### `/create-client-migration`

Creates a complete client setup:
- Migration file for `{client}_api_cache` table
- Client routes file with process and entity routes
- Stub implementations ready to customize

**Interactive prompts for:**
- Client name
- APIs used (MSExchange, Pilotphone, etc.)
- Entities managed (reservations, vehicles, agents, etc.)

**Use case:** When adding a new client to the system.

**Example:**
```bash
/create-client-migration
# Prompts for: client name, APIs, entities
php code/scripts/migrate.php up
```

**Generated routes:**
- `process-{client}` (POST) - Cache synchronization
- `{entity}` (GET) - Get all entities
- `{entity}/{id}` (GET) - Get entity by ID

### `/analyze-api-cache <client_name>`

Analyzes API routes, cache keys, and data structures for a client, then generates:
- Database consolidation schema proposals
- Duplicate `test_*` tables for testing
- Migration file ready to execute

**Use case:**
- Consolidating cached data into structured tables
- Creating test tables for integration tests
- Understanding data flows for a client

**Example:**
```bash
/analyze-api-cache halpades
php code/scripts/migrate.php up
```

**Features:**
- ✅ Automatic code analysis (finds all `api_store_result()` calls)
- ✅ Cache data structure analysis
- ✅ Smart table proposals based on data patterns
- ✅ Automatic `test_*` table generation
- ✅ Ready-to-use migration file

### `/fix-phpstan`

Fixes PHPStan errors iteratively until 0 errors remain. Documents common error types and their fixes.

**Use case:**
- Ensuring code quality and type safety
- Compliance with PHPStan level 5
- Adding missing PHPDoc comments
- Fixing undefined functions

**Process:**
1. Run `composer phpstan` to identify errors
2. Work with Claude to fix errors
3. Verify fixes by re-running PHPStan
4. Repeat until 0 errors

**Common fixes:**
- Add missing PHPDoc blocks
- Create stub functions for undefined functions
- Add type hints to parameters and returns
- Remove dead catch blocks

**Example:**
```bash
composer phpstan  # See errors
# Work with Claude to fix
composer phpstan  # Verify: 0 errors ✅
```

## Workflow Complet Documentation

### Scénario : Développement Feature Complète

```bash
# 1. Développement
vim apis/sync.php
composer test

# 2. Synchronisation automatique docs
/update-docs apis/sync.php
# → Génère docs API, PHPDoc, exemples

# 3. Vérification memory bank
/check-memory
# Si > 70% :
/optimize-memory
# → Consolide, crée quick refs

# 4. Review code
/review-and-fix
# → Détecte issues, propose fixes

# 5. Commit
git add . && git commit -m "feat: add endpoint + docs"
```

### Scénario : Maintenance Mensuelle

```bash
# 1. Nettoyage fichiers temporaires
/clean-docs
# → Archive reviews, tasks, prompts > 30j

# 2. Optimisation memory bank
/optimize-memory
# → Consolide redondances

# 3. Vérification qualité code
composer phpstan
# Si erreurs :
/fix-phpstan
```

---

## Documentation vs Optimisation : Quelle Commande ?

| Besoin | Commande | Agent |
|--------|----------|-------|
| Code modifié → docs à sync | `/update-docs` | - |
| Memory bank > 70% | `/optimize-memory` | `documentation-architect` |
| Fichiers temp à nettoyer | `/clean-docs` | `documentation-architect` |
| Guide rapide à créer | `/doc-quick-ref` | `documentation-architect` |

**Règle d'or** :
- `/update-docs` = **génération** depuis code
- `/optimize-memory` = **optimisation** docs existantes
- `/clean-docs` = **nettoyage** fichiers obsolètes

---

## Adding New Commands

To add a new slash command:

1. Create a new `.md` file in this directory
2. Document the command usage and behavior
3. If the command requires a supporting script, create it in the `code/scripts/` directory
4. Update this README with the new command information

## Related Documentation

- **Agents:** `.claude/agents/README.md` - Available agents
- **Skills:** `.claude/skills/README.md` - Reusable capabilities
- **Project Instructions:** `../CLAUDE.md` - Project standards
