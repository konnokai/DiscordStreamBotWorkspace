---
name: YouTube start notification fallback
description: StreamRecordTools start-notification guard for yt-dlp no-format failures.
---

# YouTube start notification fallback

- `StreamRecordTools.Command.Record.YouTube` sends the existing cross-repo `youtube.startstream` Redis event. A yt-dlp warning alone does not prove that a scheduled stream started: `Video should already be available according to extracted info` can recur after its scheduled time while the host is still offline.
- These outputs trigger a YouTube Data API check: `Video should already be available according to extracted info`, `Only images are available for download`, `Requested format is not available`, and `No video formats found`. Send the normal start event only when `ActualStartTimeDateTimeOffset` exists and `ActualEndTimeDateTimeOffset` is absent. Serialize checks with `SemaphoreSlim` so shutdown waits for an in-flight check.
- As of 2026-11-27, wait-warning API checks are throttled to once per five minutes. Explicit no-format and final shutdown checks bypass the throttle. The wait-warning interval was previously one minute; five minutes reduces quota use.
- If the stream is API-confirmed live but only the wait warning appeared, delay the owner alert until at least three minutes after actual start. Explicit no-format output triggers the owner alert immediately. See [[youtube-ytdlp-error-owner-dm]].
- Retry a failed `youtube.startstream` publish from the recording watchdog every 10 seconds. The per-recording send guard is set only after successful publish and also covers the actual recording-file-growth path. Add the video to `youtube.nowRecord` only when recording data starts growing; a failed no-format attempt must not appear active.
- Set the unrecordable flag before killing yt-dlp for member-only, private, or removed videos, and suppress the generic no-format path afterward. This avoids a second ordinary start event after a member-only event.
- Exclude n-challenge warnings: they can mean only some formats are missing. See [[yt-dlp-youtube-challenge]]. The `This live event has ended` case still had no fallback start notice in the 2026-11-27 review.
- On normal completion, remove the video's `youtube.nowRecord` marker even when recording is rejected as member-only, private, or removed. Skip removal after handing off to a new container; otherwise the old container can erase the new container's marker. Return `Error` after cleanup for unrecordable results.
- As of 2026-11-27, a handed-off marker can remain if the new container never starts; there is no TTL. This may cause an extra confirmation prompt but does not stop recording.
- Superseded 2026-11-27 behavior: wait-warning API checks were once throttled to one minute, and the old container could remove the new container's `youtube.nowRecord` marker after handoff. The final change uses the five-minute throttle and skips handoff cleanup.
- On 2026-11-27, `dotnet test StreamRecordTools.sln -c Release --nologo` passed 61 tests. The Bot solution build passed with 0 warnings and 0 errors. Redis-to-Discord behavior was not integration-tested.
- The fix was merged and pushed on 2026-11-27: StreamRecordTools `461f435`, DiscordStreamNotifyBot `af2e3e5`. The workspace gitlink update was also pushed; see [[workspace-meta-repo-submodules]].
