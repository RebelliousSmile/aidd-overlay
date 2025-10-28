Invoke the `documentation-architect` agent to create a quick reference guide for a specific component or pattern.

Provide the component/pattern name as argument:
- `/doc-quick-ref circuit-breakers` : Create quick ref for circuit breaker pattern
- `/doc-quick-ref sync-api` : Create quick ref for Sync API
- `/doc-quick-ref cache-resilience` : Create quick ref for cache patterns

The agent will:
1. Consult existing documentation
2. Delegate to `software-architect` or `product-owner-functional` if needed
3. Create a 3-tier guide:
   - TL;DR (30 seconds)
   - Quick Reference (5 minutes) with code examples
   - Link to deep dive documentation
4. Optimize for memory bank (< 2k tokens)
5. Add to appropriate location in `documentation/`

The guide will include:
- Core concepts and principles
- Most common use cases with code
- Frequent pitfalls to avoid
- Links to full documentation
- References to actual code locations

Use this command when:
- You need concise reference for a pattern
- Existing docs are too verbose
- You want to onboard developers quickly
- You frequently access the same information
