---
name: OpenCode project skills
description: Bot skill location and workspace-root discovery configuration.
---

# OpenCode project skills

- Bot-specific skills live under `DiscordStreamNotifyBot/.opencode/skills/<skill-id>/SKILL.md`.
- The workspace-root `opencode.jsonc` adds `./DiscordStreamNotifyBot/.opencode/skills` so sessions started at the workspace root can discover Bot skills. This setup loaded `ef-migration-baseline` successfully on 2026-11-23.
- The old Bot Graphify skill was not migrated: on 2026-11-23 its version was `0.9.10`, while the global skill was `0.9.104`. Keep Graphify as the global skill rather than restoring the stale project copy; see [[graphify-query-guidance]].
