---
name: YouTube yt-dlp error owner DM
description: Cross-repo no-format alert path, global deduplication window and delivery limits.
---

# YouTube yt-dlp error owner DM

- `StreamRecordTools` treats `only images are available for download`, `Requested format is not available`, and `No video formats found` as explicit no-format errors. It publishes `youtube.ytdlp.error` with `{videoId}:{first 500 characters of the error line}` after a successful Redis Pub/Sub publish; a publish with no subscribers logs a warning and remains retryable. n-challenge warnings are excluded because other formats, including SABR, may still work; see [[yt-dlp-youtube-challenge]].
- The Bot Scraper accepts only an 11-character video ID, then republishes the error as `youtube_ytdlp_error` on the NotificationBus. `PublishOnceAsync` uses the global key `youtube:ytdlp_error` with a 24-hour TTL, so the alert is globally limited to one per rolling 24 hours, not one per video. The key is consumed when the bus event is published, not when the owner receives a DM.
- The Notifier sends the owner DM only from shard 0. If Discord is not ready, the handler throws so the bus can retry; if the owner cannot receive DMs, it logs and acknowledges the event. A failed delivery can therefore still consume the global 24-hour window.
- An explicit no-format error sends the owner alert immediately. If only the repeated “Video should already be available according to extracted info” wait warning occurs, API confirmation gates the start event, and the owner alert waits until the stream has been live for at least three minutes. See [[youtube-start-notification-fallback]].
- On 2026-11-27, the StreamRecordTools suite passed 61 tests and the Bot solution built with 0 warnings and 0 errors. The Redis-to-Discord path was not integration-tested. The changes were merged and pushed: StreamRecordTools `461f435` and DiscordStreamNotifyBot `af2e3e5`; see [[youtube-start-notification-fallback]].
