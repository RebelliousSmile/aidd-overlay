# Documentation Sync Report

**Date**: [YYYY-MM-DD]
**Scope**: [What was analyzed - branch, directory, files]
**Changes analyzed**: [X] files
**Documents updated**: [Y] files

## Changes Detected

### PHP Code Modified

| File | Changes | New Functions |
|------|---------|---------------|
| `code/path/file.php` | +X/-Y lines | `function_name()` |

### Database Changes

| Migration | Tables Affected |
|-----------|-----------------|
| `YYYYMMDD_name.php` | `table_name` |

## Documentation Updates

### Applied
- ✅ `path/to/doc.md` - [What was updated]
- ✅ `path/to/doc2.md` - [What was updated]

### Skipped (no changes needed)
- ⏭️ `path/to/doc3.md` - Already up to date

### Needs Manual Review
- ⚠️ `path/to/doc4.md` - [Why manual review needed]

## PHPDoc Status

| Category | Count | Percentage |
|----------|-------|------------|
| With PHPDoc | X | Y% |
| Missing PHPDoc | Z | W% |

### Missing PHPDoc (action required)
1. `file.php:123` - `function_name()`
2. `file.php:456` - `other_function()`

## Consistency Checks

- [x] All new functions documented
- [x] Database schema matches docs
- [x] API routes documented
- [ ] [Any failing check with details]

## Token Impact

| Document | Before | After | Delta |
|----------|--------|-------|-------|
| `doc1.md` | 1.2k | 1.5k | +300 |
| `doc2.md` | 2.0k | 2.0k | 0 |
| **Total** | 3.2k | 3.5k | +300 |

## Next Steps

1. [ ] [Action item 1]
2. [ ] [Action item 2]
3. [ ] Commit: "docs: [description]"

---
**Generated**: [YYYY-MM-DD HH:MM]
**Skill**: documentation-sync (mode: sync)
