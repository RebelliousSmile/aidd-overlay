---
name: update-docs
description: Maintains documentation up to date after code changes (sync code → docs)
---

# Command: Update Documentation

You will automate documentation updates after code changes.

**NOTE**: This command focuses on **code → documentation synchronization**.
For **memory bank optimization** and **temporary file cleanup**,
use `/optimize-memory` or `/clean-docs` (`documentation-architect` agent) instead.

## Complementarity with documentation-architect

- `/update-docs`: After code modification (automatic sync)
- `/optimize-memory`: Memory bank maintenance (periodic optimization)
- `/clean-docs`: Temporary file cleanup (archiving/deletion)

## Step 0: Initialize Tracking

Use TodoWrite to create a tracking todo list with these tasks:
- Analyze recent changes (git diff)
- Identify impacted documentation files
- Generate necessary updates
- Validate consistency with code
- Create update report

Mark each task as `in_progress` before executing and `completed` after.

## Step 1: Analyze Changes

### 1.1 Detect Modifications

Execute `git diff` to identify recent changes:
```bash
git diff HEAD~1 HEAD --name-status
```

If user specifies a commit or branch, use that instead.

### 1.2 Categorize Changes

For each modified file, identify category:

**Modified PHP code** (requires documentation update):
- `clients/*.php` → `documentation/notebooks/client/*.md`
- `apis/*.php` → `documentation/notebooks/api/*.md`
- `providers/*.php` → `documentation/notebooks/api/*.md`
- `database/*.php` → `documentation/notebooks/architecture/database/*.md` + `documentation/notebooks/architecture/database-schema-complete.md`
- `routes/*.php` → `documentation/notebooks/api/*.md`

**New functions added**:
- Extract function signatures with `grep -n "^function "`
- Check for PHPDoc presence
- Identify prefix (`client_`, `api_`, `provider_`, `db_`, `auth_`)

**New tables/migrations**:
- `code/scripts/migrate.php` modified → `documentation/notebooks/architecture/database/*.md`
- New tables → `documentation/notebooks/architecture/database-schema-complete.md`

## Step 2: Identify Impacted Documents

### 2.1 Automatic Mapping

For each change, determine documentation files to update:

| Code Change | Impacted Documentation |
|-------------|------------------------|
| `clients/cosyhosting.php` | `documentation/notebooks/api/guesty.md` |
| `clients/onet.php` | `documentation/notebooks/client/onet.md`, `documentation/notebooks/api/pilotphone.md` |
| `clients/halpades.php` | `documentation/notebooks/client/halpades.md` |
| `apis/sync.php` | `documentation/notebooks/api/sync.md` |
| `apis/guesty.php` | `documentation/notebooks/api/guesty.md` |
| `database/mysql.php` | `documentation/notebooks/architecture/database-schema-complete.md` |
| `routes/*.php` | `documentation/notebooks/api/README.md` |
| `authentication.php` | `documentation/authentication.md` |

### 2.2 Cross-cutting Documentation

Some changes impact multiple documents:

**Architecture modified**:
- Structural changes → `documentation/notebooks/architecture/03-component-architecture.md`
- New patterns → `documentation/notebooks/architecture/patterns-architecture.md`
- Security → `documentation/notebooks/architecture/06-security-architecture.md`

**New features**:
- User stories → `documentation/notebooks/architecture/user-stories.md`
- User flows → `documentation/notebooks/architecture/parcours-utilisateur.md`

## Step 3: Generate Updates

### 3.1 API Documentation

For each modified/added API function:

1. **Read source code** and extract:
   - Function signature
   - Parameters (types, PHPDoc descriptions)
   - Return value
   - Usage example in code

2. **Update corresponding Markdown file**

### 3.2 Database Documentation

For each new table or schema modification, create/update appropriate documentation files.

### 3.3 PHPDoc Verification

For each public function without PHPDoc or with incomplete PHPDoc:

1. **Auto-generate** PHPDoc
2. **Request validation** from user before applying

## Step 4: Validate Modifications

### 4.1 Basic Checks

**Before applying changes, verify**:
- Valid Markdown syntax
- Syntactically correct PHP code examples
- Internal links to existing files
- Well-formatted PHPDoc

**NOTE**: For complete documentation/code consistency audit,
use `/optimize-memory` which delegates to `documentation-architect`.

## Step 5: Propose Updates

### 5.1 Suggested Modifications

For each documentation file to modify:

1. **Display a diff** of proposed changes
2. **Request confirmation** from user
3. **Apply modifications** if accepted

### 5.2 New Files

If new documentation files are needed:

1. **Propose creation** with appropriate template
2. **Auto-fill** with data extracted from code

## Step 6: Generate Final Report

Display concise report (< 20 lines):

```markdown
# 📝 Documentation Update Report

**Summary**: X functions documented, Y tables added

## Applied Changes
- ✅ `api/sync.md` - Added `sync_new_function()`
- ✅ `database-schema-complete.md` - Table `new_table`
- ✅ PHPDoc added on 3 functions

## Next Steps
1. `php code/scripts/generate_bruno_collection.php` (if APIs modified)
2. `composer test && composer phpstan`
3. Commit: "docs: update after [changes]"

**Optimization**: If large docs created, execute `/optimize-memory`
```

## Important Rules

### ❌ NEVER

- Delete existing documentation without explicit validation
- Modify code examples without testing them
- Create new documentation files without asking
- Overwrite manually written business descriptions

### ✅ ALWAYS

- Preserve existing functional descriptions
- Validate changes with user before applying
- Respect existing templates in `documentation/templates/`
- Maintain consistency with `CLAUDE.md`
- Check cross-reference consistency between documents

## Advanced Options

### Targeted Analysis

User can specify:
- **Specific file**: `/update-docs routes/sync.php`
- **Directory**: `/update-docs clients/`
- **Commit range**: `/update-docs HEAD~5..HEAD`
- **Doc type**: `/update-docs --api` (API documentation only)

### Execution Modes

- **Interactive mode** (default): Request confirmation for each change
- **Automatic mode**: `--auto` - Apply all changes without confirmation
- **Report only mode**: `--dry-run` - Display only what would be modified
