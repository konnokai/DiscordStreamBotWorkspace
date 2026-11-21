---
name: YouTube Issue Monitor input shape
description: Nested issue fields in fetched YouTube Issue Monitor analysis input.
---

# YouTube Issue Monitor input shape

- In fetch inputs observed on 2026-11-20 and 2026-11-21, each `issues[]` item has `summary` (`id`, `title`, `status`, `modified_time`, `url`), `document` (including `summary`, `description`, `comments`, `status_update`), `needs_analysis`, and `previous_analysis`.
- Read issue identity and title from `item.summary.id` and `item.summary.title`; direct `item.id` and `item.title` were empty in a PowerShell inspection.
- A 2026-11-13 input also had a top-level `resolved_tasks` object (empty value serialized as `{}`), not an array. Check current output if parsing resolved tasks.
- For nested PowerShell inspection, a `pwsh -Command "$j = ..."` invocation lost the assignment variable and failed; writing the commands to a `.ps1` and running `pwsh -NoProfile -File <script>` worked.
- Verify the current model before relying on this shape if the tool changes. Bot API call paths used during issue triage are summarized in [[bot-youtube-api-surface]].
