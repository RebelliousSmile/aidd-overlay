# SmartLockers Client Manager - Claude Code Agents

This directory contains project-specific sub-agents for Claude Code specialized task delegation.

## Available Agents

### 🔧 claude-code-optimizer

**Purpose:** Expert in Claude Code configuration and optimization

**Use PROACTIVELY for:**
- Auditing Claude Code setup (skills, agents, commands, hooks)
- Improving configuration based on official best practices
- Optimizing existing components for better performance
- Fixing YAML frontmatter issues
- Creating new skills/agents when needed
- Consulting latest Claude Code documentation

**Key Capabilities:**
- ✅ Audits entire `.claude/` directory structure
- ✅ Validates YAML frontmatter syntax
- ✅ Fetches latest official documentation
- ✅ Provides detailed optimization reports
- ✅ Implements improvements incrementally
- ✅ Documents rationale for all changes

**Tools:** Read, Write, Edit, Grep, Glob, Bash, WebFetch

**Example Invocations:**
```
"Optimize my Claude Code setup"
"Audit my .claude/ configuration"
"Check if my skills follow best practices"
```

---

### 📚 documentation-architect

**Purpose:** Expert in documentation and memory bank optimization for SmartLockers project

**Use PROACTIVELY when:**
- User mentions "documentation", "memory", "context", "docs"
- Memory bank usage > 70% (check with `/context`)
- After completing major tasks/reviews
- Need to create quick reference guides

**Key Capabilities:**
- ✅ Audits memory bank usage and proposes optimizations
- ✅ Cleans temporary files (reviews, tasks, prompts > 30 days)
- ✅ Creates concise quick-reference guides (< 2k tokens)
- ✅ Consolidates redundant documentation
- ✅ Delegates to other agents for specialized decisions (software-architect, product-owner-functional)
- ❌ **NEVER modifies CLAUDE.md without explicit confirmation**

**Tools:** Read, Write, Edit, Glob, Grep, Bash, Task

**Slash Commands:**
```
/optimize-memory              # Audit memory bank + propose optimizations
/clean-docs                   # Clean temporary documentation files
/doc-quick-ref [component]    # Create quick reference guide
```

**Common Use Cases:**

**1. Memory Bank Optimization (> 70% usage)**
```bash
/optimize-memory
```
Agent analyzes memory bank, identifies heavy files, proposes consolidations.

**2. Cleanup Temporary Files**
```bash
/clean-docs
```
Agent scans for old reviews/tasks, proposes archiving to `.archive/YYYY-MM/`.

**3. Create Quick Reference**
```bash
/doc-quick-ref circuit-breakers
```
Agent creates 3-level guide: TL;DR (30s) → Quick Ref (5min) → Deep Dive (links).

**Example Invocations:**
```
"Memory bank is at 75%, optimize"
"Clean up old review files"
"Create quick reference for cache-resilience pattern"
```

**Collaboration:**
- Delegates to `software-architect` for architecture decisions
- Delegates to `product-owner-functional` for functional priorities
- Works with `claude-code-optimizer` for Claude Code configuration
- Works with `client-creator` for new client setup

---

### 🏗️ software-architect

**Purpose:** Expert en architecture logicielle SmartLockers

**Use PROACTIVELY when:**
- Architecture decisions needed
- Pattern selection (cache, resilience, performance)
- Refactoring proposals
- Technical design validation
- Performance optimization

**Key Capabilities:**
- ✅ Validates architectural decisions against SmartLockers constraints
- ✅ Proposes 3 options (conservative, pragmatic, innovative) for each decision
- ✅ Enforces functional architecture (no classes)
- ✅ Ensures cache-first pattern compliance
- ✅ Validates multi-tenant isolation
- ✅ Reviews performance implications

**Tools:** Read, Grep, Glob, Bash

**Example Invocations:**
```
"What pattern should I use for Beds24 API calls?"
"Should I create a new table for this data?"
"How to implement credentials update securely?"
"Review this refactoring proposal"
```

**Typical response:** 3 options with pros/cons/effort + recommendation

---

### 📋 product-owner-functional

**Purpose:** Expert métier SmartLockers (business rules and priorities)

**Use PROACTIVELY when:**
- Business rules validation needed
- Functional specifications unclear
- User story definition
- Feature prioritization
- Client-specific requirements

**Key Capabilities:**
- ✅ Validates business rules compliance
- ✅ Defines testable acceptance criteria
- ✅ Prioritizes features (P0/P1/P2/P3)
- ✅ Knows client specifics (ONET, CosyHosting, Halpades, Lock and Chill)
- ✅ Ensures multi-tenant business logic

**Tools:** Read, Grep, Glob

**Example Invocations:**
```
"What are the business rules for locker allocation?"
"Should we allow booking cancellation after check-in?"
"Define acceptance criteria for credentials update feature"
"Which client has priority for this feature?"
```

**Collaboration:**
- Consults `software-architect` for technical feasibility
- Consults `documentation-architect` for business rules documentation

---

### 🤖 client-creator

**Purpose:** Automated client creation with complete workflow

**Use for:**
- Creating new SmartLockers clients (generates all boilerplate)
- Setting up credentials, tables, collections, tests
- Validating client setup

**Key Capabilities:**
- ✅ Generates client functions file with routes
- ✅ Creates database tables (cache + business)
- ✅ Bootstraps credentials (Bearer token, machine login/password)
- ✅ Generates Bruno API collection
- ✅ Creates contract tests
- ✅ Validates setup with PHPStan

**Tools:** Read, Write, Edit, Bash, Grep, Glob

**Example Invocations:**
```
"Create new client mycompany with Stripe and Mailgun APIs"
"/new-client acme --apis=Beds24"
```

**Typical workflow:** 10-15 minutes (vs 30-45 min manual), -67% time, -80% errors

---

## How Sub-Agents Work

### Automatic Delegation

Claude Code proactively delegates to agents when:
- Task description matches agent's expertise
- Agent description includes "PROACTIVELY" keyword
- Context suggests specialized knowledge needed

### Explicit Invocation

You can manually request specific agents:
```
"Use the claude-code-optimizer agent to audit my setup"
```

### Independent Context

Each agent:
- Has its own context window (separate from main conversation)
- Uses specific tools configured in its definition
- Follows its custom system prompt
- Can use different models (sonnet, opus, haiku, or inherit)

## Agent Structure

Each agent is a markdown file with YAML frontmatter:

```markdown
---
name: agent-name
description: When and why to invoke this agent
tools: Tool1, Tool2, Tool3  # Optional, inherits all if omitted
model: sonnet               # Optional, uses configured default if omitted
---

System prompt describing role, expertise, and workflow...
```

## Creating New Agents

### Quick Method (Recommended)

1. Run `/agents` command in Claude Code
2. Select "Create New Agent"
3. Choose "Project" scope (shared with team)
4. Define agent with interactive prompts

### Manual Method

1. Create file: `.claude/agents/agent-name.md`
2. Add YAML frontmatter with required fields
3. Write detailed system prompt
4. Save and agent is automatically discovered

## Best Practices

### Agent Design

- ✅ **Single responsibility:** One focused purpose per agent
- ✅ **Clear description:** Include "use when..." or "PROACTIVELY" triggers
- ✅ **Minimal tools:** Only grant necessary tool access
- ✅ **Detailed prompts:** Provide examples, workflows, checklists
- ✅ **Inherit model:** Use `model: inherit` unless specific model needed

### Tool Restrictions

Limit tool access to minimum required:
- **Code review:** Read, Grep, Glob, Bash
- **Documentation:** Read, Write, WebFetch
- **Testing:** Read, Bash
- **Optimization:** All tools (for this meta-agent)

### System Prompt Quality

Good system prompts include:
1. Clear role definition
2. Specific responsibilities
3. Step-by-step workflows
4. Examples and templates
5. Quality checklists
6. Error patterns to detect
7. Communication style guidelines

## Version Control

**Project agents** (in `.claude/agents/`) are:
- ✅ Checked into git
- ✅ Shared with all team members
- ✅ Versioned with the codebase
- ✅ Automatically available to everyone

**User agents** (in `~/.claude/agents/`) are:
- Personal to individual developer
- Not shared via git
- Available across all projects

## Management

### Using `/agents` Command

```bash
# View all agents
/agents

# Create new agent (interactive)
/agents create

# Edit existing agent
/agents edit agent-name

# Delete agent
/agents delete agent-name
```

### Direct File Management

```bash
# List all project agents
ls -la .claude/agents/

# Edit agent
vim .claude/agents/agent-name.md

# Delete agent
rm .claude/agents/agent-name.md
```

## Practical Tips

### Working with documentation-architect

**Tip 1: Check memory before optimizing**
```bash
/context              # See current memory usage
/optimize-memory      # If > 70%, optimize
```

**Tip 2: Archive first, delete later**
Start conservative, become aggressive once confident:
1. First month: ALWAYS archive to `.archive/YYYY-MM/`
2. After validation: Delete truly useless files
3. Routine: Archive monthly, purge archives > 6 months

**Tip 3: Create quick refs for frequently consulted docs**
If you consult a doc often (> 3 times/week):
```bash
/doc-quick-ref component-name
```
Creates concise guide (< 2k tokens vs full doc).

**Tip 4: Combine with claude-code-optimizer**
For complete optimization:
```bash
/optimize-memory                        # Memory bank
"@claude-code-optimizer audit .claude/" # Configuration
```

## Integration with SmartLockers

### Project-Specific Context

All agents have access to:
- **CLAUDE.md** - Project instructions and standards
- **Memory Bank** - `documentation/memory-bank/` (core + guides)
- **Documentation** - `documentation/` directory (architecture, API, functional)
- **Codebase** - All source files via Read/Grep/Glob tools

### SmartLockers Standards

Agents enforce project conventions:
- Architecture fonctionnelle pure (no classes)
- Function naming (snake_case with prefixes: `client_`, `api_`, `db_`, `auth_`)
- Cache-first pattern (update cache ONLY on HTTP 2xx)
- Bearer token auth (stateless, no sessions)
- PHPStan niveau 6 compliance (0 errors)
- 70/20/10 testing strategy (PHPStan 70%, Contracts 20%, Integration 10%)
- UUID usage for lockers (not numeric IDs)
- Multi-tenant isolation (table prefixes, no cross-access)

## Troubleshooting

### Agent Not Triggering

1. **Check description:** Must include clear trigger conditions
2. **Verify YAML:** Syntax must be valid
3. **Add PROACTIVELY:** Include keyword in description
4. **Restart Claude Code:** Changes may need session restart

### YAML Validation Errors

Common issues:
- ❌ Tabs instead of spaces
- ❌ Missing closing `---`
- ❌ Invalid field names (use hyphens, not underscores)
- ❌ Tool names don't match available tools

### Agent Using Wrong Tools

- Check `tools:` field in frontmatter
- Ensure tool names are comma-separated
- Omit field to inherit all tools

## Resources

- **Official Docs:** https://docs.claude.com/en/docs/claude-code/sub-agents.md
- **Project Instructions:** `../CLAUDE.md`
- **Skills:** `.claude/skills/`
- **Slash Commands:** `.claude/commands/`

## Related Components

- **Skills** (`.claude/skills/`) - Reusable capabilities for main conversation
- **Slash Commands** (`.claude/commands/`) - Custom CLI commands
- **Plugins** - Bundled tools and agents from marketplace
- **Hooks** (`.claude/hooks/`) - Automated responses to events
