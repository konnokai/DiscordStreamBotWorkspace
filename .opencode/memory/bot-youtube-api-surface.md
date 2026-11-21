---
name: Bot YouTube Data API surface
description: YouTube Data API call paths observed in the Bot source scan on 2026-11-21.
---

# Bot YouTube Data API surface

- The 2026-11-21 source scan found `videos.list` with `snippet,liveStreamingDetails` or `contentDetails`; `channels.list` with `id`, `snippet`, or `id,snippet`; `playlistItems.list` with `snippet`; and `commentThreads.list` with `id` or `snippet`.
- Membership authorization uses `channels.list(id, mine=true)` and member probing uses `commentThreads.list(id)`; the probe does not read comment metadata. See [[bot-youtube-member-authorization]].
- `YoutubeDetectionService.MemberVideo.cs` makes one `playlistItems.list` request and does not read `nextPageToken`; pagination-only upstream issues do not match this call path.
- A 2026-11-14 Bot source check found no iframe, `playerVars`, IFrame Player API, `liveChatMessages`, or `liveBroadcasts` use. `EmbedBuilderFactory.CreateVideoEmbed` links to the YouTube watch page and uses a thumbnail; recheck source before relying on these absences.
- The same scan found no YouTube Analytics API or Google `localizations` property use in Bot C# code. Recheck current source before relying on these absences.
