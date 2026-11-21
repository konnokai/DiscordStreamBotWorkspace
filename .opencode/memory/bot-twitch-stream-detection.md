---
name: Bot Twitch stream detection
description: Twitch EventSub start handling, offline debounce, lifecycle deduplication, notification, and recording behavior.
---

# Bot Twitch stream detection

- Twitch offline confirmation waits 3 minutes before treating a stream as offline.
- `HandleStreamStartedAsync` cancels `_streamOfflineReminders`; `CancelOfflineReminder` returns `bool` indicating whether a pending offline confirmation was cancelled.
- If a start event arrives while offline confirmation is still pending, treat it as a process duplicate even when the Twitch stream ID changed: refresh stream state and EventSub, but do not publish `StartStream`.
- Root cause of the earlier false start: a reconnect could produce a new stream ID, so stream-ID, process, Redis, and DB dedup all missed it.
- Loki confirmed same-second duplicate notifier logs came from different shards (`notifier:0` and `notifier:1`), not one shard re-sending.
- Fix landed in `TwitchDetectionService.cs` (2 lines) on 2026-08-14; focused `TwitchStreamLifecycleDecisionTests` 17 passed; committed as `8b3f6bb` on `claude-fable5` and pushed.
- 2026-08-31 resumed-stream persistence fix: `TwitchStreamStartPolicy` now distinguishes a duplicate whose StreamId is absent from `TwitchStreams` as `PersistStreamAndRefreshState`; `HandleStreamStartedAsync` adds and saves that `TwitchStream` before refreshing Redis state/EventSub, then returns without recording or publishing `StartStream`. Existing DB duplicates remain `RefreshStateOnly`. Preserves `CancelOfflineReminder`-based notification suppression while restoring the historical row. Verification: Release build 0 warnings/errors; focused `TwitchStreamLifecycleDecisionTests` 20 passed; full suite 632 passed + 36 skipped; git diff --check passed.
- `stream.online` uses EventSub `Id` and `StartedAt` directly; it does not wait for Helix `Get Streams`. Parse `StartedAt` as `DateTimeOffset?` and convert to UTC. Missing ID/time and events older than 10 minutes are ignored; the 5-minute low-frequency poll can recover a still-live stream. This age limit is fixed, not a config setting.
- EventSub and Helix polling share `HandleStreamStartedAsync(TwitchStream)` and deduplicate with the stream ID across DB, process memory, and Redis. Channel title/category come from Helix `GetChannelInformationAsync`; on failure use prior Redis state or empty values without blocking notification. Build the thumbnail URL from broadcaster login and skip the embed image if it is empty.
- Preserve the 3-minute pending-offline behavior: an online event received while its offline reminder is pending cancels the reminder and suppresses the start notification. Once the end handler confirms offline, it removes only its own `(userId, cancellation)` reminder entry immediately, so a later online event is treated as a new start rather than a resume. The `finally` identity check remains necessary.
- 2026-11-08 review did not verify that EventSub `Id` equals Helix stream `Id` with a real event. Confirm this before relying on cross-path dedup; otherwise the poll may create a duplicate row/notification. Real Twitch/Streamlink timing was also not manually tested.
- The earlier online event now reaches StreamRecordTools before Helix may list the stream. `StreamRecordTools/StreamRecordTools/Command/Record/Twitch.cs` uses `Streams?.FirstOrDefault()` and catches Helix lookup errors so recording continues with its default filename. If an early Streamlink request fails because HLS is not ready, verify that in production before adding retries.
- 2026-11-08 verification: Bot Release build (5 projects), StreamRecordTools Release build (1 project), and Bot `git diff --check` passed. Bot merge `a144e98` and StreamRecordTools commit `2f5e5ab` were pushed to their respective `origin/master` branches.
- Related: [[bot-admin-settings-service]] for admin snapshot/command handling.
