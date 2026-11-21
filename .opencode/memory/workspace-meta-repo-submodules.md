---
name: Workspace Git submodules
description: Meta-repo decision, safe submodule setup, and pull-script verification limits.
---

# Workspace Git submodules

- Decision (2026-11-21): Keep the five repositories independent and use the private `konnokai/DiscordStreamBotWorkspace` meta repo to pin their commits. This preserves repository history and deployment units while recording a compatible set for shared contracts; see [[database-schema-ownership]].
- When wrapping existing clones, commit only the meta-repo shell files before running `git submodule add`. Staging child folders first records embedded repositories and makes `submodule add` fail with `already exists in the index`.
- Fresh checkout uses `git clone --recurse-submodules`. This was verified against the local meta repo on 2026-11-21; all five pinned repositories checked out.
- `git-pull-all.bat` reads submodule paths from `.gitmodules`, pulls the workspace, then runs `git pull --ff-only` in each child. On 2026-11-21, `cmd /c "echo.|git-pull-all.bat"` passed with five submodules successful and zero failures while all were already up to date.
- A new child commit does not update the parent gitlink. After advancing child repositories, update and commit the meta repo's gitlinks. Pulling children while the pins stay old makes the parent show a submodule commit mismatch.
- Verification limit (2026-11-21): the batch script was not tested with new remote commits or divergent child branches.
