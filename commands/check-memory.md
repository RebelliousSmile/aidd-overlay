# Check Memory Bank Consistency

Verify Claude Code memory bank coherence and integrity.

## Objective

Automatically detect:
- Referenced but missing files
- Duplicates in CLAUDE.md
- Inconsistencies between estimated and actual size
- Optimization opportunities

## Actions to Execute

### 1. Analyze CLAUDE.md

Read `/home/tnn/Projets/SmartLockers/middleware/CLAUDE.md` and extract all `@documentation/...` references.

### 2. Verify Existence

For each referenced file, verify it exists on disk.

### 3. Detect Duplicates

Identify files referenced multiple times.

### 4. Estimate Tokens

Compare token estimates in comments vs actual file sizes.

### 5. Suggest Improvements

Based on `claude-code-optimizer` recommendations, suggest files to add or remove.

## Output Format

Produce structured report:

```markdown
## 📊 Memory Bank Health Check

**Date**: 2025-10-24
**Files analyzed**: X references in CLAUDE.md

### ✅ Global Status

- Valid files: X/X
- Missing files: 0
- Detected duplicates: 0
- Inconsistencies: 0

### 📁 Loaded Files

1. ✅ CLAUDE.md (4.0k tokens estimated, 4.2k actual)
2. ✅ architecture/README.md (1.5k tokens estimated, 1.6k actual)
3. ❌ **MISSING**: architecture/11-api-integration-patterns.md
4. ⚠️ **DUPLICATE**: api/sync.md (referenced twice lines 42 and 58)

### 💡 Recommendations

1. **Add**: architecture/11-api-integration-patterns.md (5.5k tokens)
2. **Add**: architecture/06-security-architecture.md (5.7k tokens)
3. **Remove duplicate**: api/sync.md line 58
4. **Total after optimization**: 67.8k tokens (34% of context)

### 🎯 Suggested Actions

- [ ] Uncomment `@documentation/architecture/11-api-integration-patterns.md`
- [ ] Uncomment `@documentation/architecture/06-security-architecture.md`
- [ ] Remove line 58 (duplicate api/sync.md)
- [ ] Re-run `/check-memory` for validation
```

## Notes

- Use `Read` to read CLAUDE.md
- Use `Bash` for `file_exists` or `wc -w`
- Use `Glob` to list documentation/ files
- DO NOT modify CLAUDE.md automatically (request confirmation)
