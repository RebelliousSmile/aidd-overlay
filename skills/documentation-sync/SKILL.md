---
name: documentation-sync
description: Automatically maintain documentation after code changes. Use PROACTIVELY when functions are added/modified, tables created, APIs changed, or user mentions documentation updates. Triggers on PHP file modifications, schema changes, new functions without PHPDoc.
tools: Read, Write, Edit, Grep, Glob, Bash
model: inherit
---

# Documentation Sync Skill

Automates documentation updates after code changes.

## Proactive Triggering

**Use this skill automatically when:**
- PHP functions are added or modified in `code/clients/`, `code/apis/`, `code/providers/`, `database/`
- Database tables are created or modified
- API routes are modified
- Missing PHPDoc detected on public functions
- User mentions: "doc", "documentation", "update doc", "sync doc"

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

For each modified file, identify the category:

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

2. **Update corresponding Markdown file**:
   ```markdown
   ### `api_function_name($param1, $param2, $config)`

   **Description**: [From PHPDoc]

   **Parameters**:
   - `$param1` (type): Description
   - `$param2` (type): Description
   - `$config` (array): Client configuration

   **Return**: array with structure:
   ```php
   [
       'status' => 'success|error',
       'data' => [...],
       'source' => 'api|cache'
   ]
   ```

   **Example**:
   ```php
   $result = api_function_name($data, 'cosyhosting', $config);
   ```
   ```

### 3.2 Database Documentation

For each new table or schema modification:

1. **Create/update** `documentation/notebooks/architecture/database/{table_name}.md`:
   ```markdown
   # Table `{table_name}`

   ## Description
   [Functional description]

   ## Schema
   ```sql
   CREATE TABLE {table_name} (
       id INT PRIMARY KEY AUTO_INCREMENT,
       -- columns...
   );
   ```

   ## Columns
   | Column | Type | Description | Constraints |
   |--------|------|-------------|-------------|
   | id | INT | Unique identifier | PRIMARY KEY |

   ## Indexes
   - PRIMARY KEY on `id`
   - INDEX on `{column}` (query performance)

   ## Relations
   - Foreign key to `{other_table}`

   ## Usage
   Used by: `php_function()` in `file.php`
   ```

2. **Update** `documentation/notebooks/architecture/database-schema-complete.md`:
   - Add new table in appropriate section
   - Update diagrams if necessary

### 3.3 PHPDoc Verification

For each public function without PHPDoc or with incomplete PHPDoc:

1. **Auto-generate** PHPDoc:
   ```php
   /**
    * [Function description from name and code]
    *
    * @param type $param Parameter description
    * @param array $config Client configuration
    * @return array Return structure
    * @throws Exception Description of possible errors
    */
   function api_example($param, array $config): array
   {
       // code...
   }
   ```

2. **Request validation** from user before applying

## Step 4: Validate Consistency

### 4.1 Automatic Checks

Execute these validations:

**Code-documentation consistency**:
- All public functions documented in .md files
- Table schemas up to date in `database-schema-complete.md`
- Testable and functional code examples

**Conventions respected**:
- `snake_case` naming with prefixes
- PHPDoc present on all public functions
- Standardized return format for APIs

**Architecture respected**:
- cache-first pattern used
- Multi-tenant isolation (prefixed tables)
- Bearer Token authentication only

### 4.2 Consistency Report

Generate a report:
```markdown
## Documentation Consistency Report

### ✅ Successful Validations
- X functions documented
- Y tables up to date in schema
- Z examples tested

### ⚠️ Warnings
- Function `xyz()` without PHPDoc
- Table `abc` missing in database-schema-complete.md
- Obsolete example in api/sync.md

### ❌ Critical Errors
- Cache pattern not respected in `code/apis/xyz.php:123`
- Multi-tenant isolation violated in `code/clients/abc.php:456`
```

## Step 5: Propose Updates

### 5.1 Suggested Modifications

For each documentation file to modify:

1. **Display a diff** of proposed changes
2. **Request confirmation** from user
3. **Apply modifications** if accepted

### 5.2 New Files

If new documentation files are needed:

1. **Propose creation** with appropriate template:
   - `documentation/notebooks/api/{service}.md` for new APIs
   - `documentation/notebooks/architecture/database/{table}.md` for new tables
   - `documentation/notebooks/client/{client}.md` for new clients

2. **Auto-fill** with data extracted from code

## Step 6: Generate Final Report

Display complete report:

```markdown
# Documentation Update Report

## 📊 Summary

- **Code files analyzed**: X files
- **Functions added/modified**: Y functions
- **Tables modified**: Z tables
- **Documents updated**: W files

## 📝 Applied Changes

### API Documentation
- [x] `documentation/notebooks/api/sync.md` - Added function `sync_new_function()`
- [x] `documentation/notebooks/api/guesty.md` - Updated `guesty_get_reservations()`

### Database Documentation
- [x] `documentation/notebooks/architecture/database/new_table.md` - Created
- [x] `documentation/notebooks/architecture/database-schema-complete.md` - Added table

### Code Documentation
- [x] PHPDoc added on 3 functions
- [x] Examples updated in 2 files

## ⚠️ Required Actions

- [ ] Validate code examples in `documentation/notebooks/api/sync.md`
- [ ] Complete business description of table `new_table`
- [ ] Test modified endpoints with Bruno

## 🚀 Next Steps

1. Execute `php code/scripts/generate_bruno_collection.php` (if APIs modified)
2. Test with `composer test`
3. Validate with `composer phpstan`
4. Commit with message: "docs: update documentation after [description changes]"
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
- Maintain consistency with `CLAUDE.md`
- Check cross-reference consistency between documents

## Historical Reference

**Before updating documentation**, consult previous updates:
```bash
ls documentation/reviews/
ls documentation/tasks/
```

Use these historical examples to:
- Maintain documentation style consistency
- Follow patterns established in previous reviews
- Learn from errors corrected in tasks
- Ensure continuity with past work

**Useful reference examples:**
- Code reviews that modified documentation
- Tasks that created new documentation sections
- Update patterns established in the project

## Technical Notes

- Use `grep`, `git diff`, and `Read` for code analysis
- Respect existing Markdown formats
- Preserve manual comments and sections
- Generate testable code examples
- Validate PHP syntax of generated examples

## Workflow Integration

This skill integrates automatically into the development workflow:

```bash
# 1. Development
vim apis/sync.php

# 2. Tests
composer test

# 3. Documentation (AUTOMATIC via skill)
# Skill triggers automatically

# 4. Bruno collection (IF API)
php code/scripts/generate_bruno_collection.php

# 5. Validation
composer phpstan

# 6. Commit
git add .
git commit -m "feat: add new sync endpoint + update docs"
```
