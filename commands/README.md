# Claude Slash Commands

This directory contains custom slash commands for the SmartLockers Client Manager project.

## Quick Reference

| Command | Category | When to Use |
|---------|----------|-------------|
| `/update-docs` | 📝 Documentation | After code modification |
| `/optimize-memory` | 📝 Documentation | Memory bank > 70% |
| `/clean-docs` | 📝 Documentation | Monthly maintenance |
| `/doc-quick-ref` | 📝 Documentation | Create quick guide |
| `/review-and-fix` | 🔍 Quality | Before commit |
| `/fix-phpstan` | 🔍 Quality | After PHPStan fails |
| `/task` | ⚙️ Workflow | Complete feature |
| `/create-client-migration` | ⚙️ Workflow | New client |
| `/check-memory` | 📊 Analysis | Daily |
| `/analyze-api-cache` | 📊 Analysis | Cache analysis |

## Available Commands

### `/create-client-migration`

Generates a database migration file to create the required API cache table for a new client.

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

### `/analyze-api-cache`

Analyzes API routes and cached data for a client, then proposes a database consolidation schema with test tables.

---

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

## 📊 Analysis Commands

### `/check-memory`

**Purpose:** Verify memory bank consistency

**When:** Daily or when issues suspected

**What it does:**
- Verifies all referenced files exist
- Detects duplicates
- Estimates token usage
- Proposes optimizations

**Example:**
```bash
/check-memory

# Result:
# - 1 missing file detected
# - 2 duplicates found
# - 5 optimization opportunities
```

---

## Complete Documentation Workflow

### Scenario: Complete Feature Development

```bash
# 1. Development
vim apis/sync.php
composer test

# 2. Automatic docs sync
/update-docs apis/sync.php
# → Generates API docs, PHPDoc, examples

# 3. Memory bank verification
/check-memory
# If > 70%:
/optimize-memory
# → Consolidates, creates quick refs

# 4. Code review
/review-and-fix
# → Detects issues, proposes fixes

# 5. Commit
git add . && git commit -m "feat: add endpoint + docs"
```

### Scenario: Monthly Maintenance

```bash
# 1. Cleanup temporary files
/clean-docs
# → Archives reviews, tasks, prompts > 30 days

# 2. Memory bank optimization
/optimize-memory
# → Consolidates redundancies

# 3. Code quality check
composer phpstan
# If errors:
/fix-phpstan
```

---

## Documentation vs Optimization: Which Command?

| Need | Command | Agent |
|------|---------|-------|
| Code modified → docs to sync | `/update-docs` | - |
| Memory bank > 70% | `/optimize-memory` | `documentation-architect` |
| Temp files to clean | `/clean-docs` | `documentation-architect` |
| Quick guide to create | `/doc-quick-ref` | `documentation-architect` |

**Golden rule**:
- `/update-docs` = **generation** from code
- `/optimize-memory` = **optimization** of existing docs
- `/clean-docs` = **cleanup** of obsolete files

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
