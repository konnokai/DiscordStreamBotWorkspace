---
name: Graph query scope and truncation
description: Graphify repo selection, query limits, and cleanup of the retired codebase-memory tool.
---

# Graph query scope and truncation

- On 2026-11-19, `graphify_query` without a valid `repo` returned the available repository names instead of inferring a target. Pass the repository that owns the code in question.
- A broad query for the Bot entry point against the Backend graph returned 281 nodes and was truncated to 44. Narrow the question to the relevant repo and symbols; treat truncated results as incomplete and verify against source.
- The tool suggested narrowing with `context_filter=["call"]` or raising `token_budget`; these suggestions were not tested in that session.
- On 2026-11-23, a broad Bot query returned 425 nodes but showed only 32 at the default budget. This confirms that broad results can hide relevant nodes.
- Codebase-memory MCP, its executable, active configuration, indexes, and PATH entry were removed on 2026-11-23. Old mentions can remain in historical backups and transcripts; they are not active configuration.
