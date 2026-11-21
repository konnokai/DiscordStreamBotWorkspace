---
name: YouTube watch-page video status
description: Shared unauthenticated YouTube watch-page status rules and caller behavior across Bot and StreamRecordTools.
---

# YouTube watch-page video status

- As of 2026-11-14, Bot Shared and StreamRecordTools keep duplicate `YoutubeVideoPage` parsers aligned. Both inspect the unauthenticated watch page; Bot also treats `"-"` as an invalid video ID. Keep parser changes synchronized.
- `LOGIN_REQUIRED` alone is ambiguous. Age signals (`AGE_VERIFICATION_REQUIRED`, `AGE_CHECK_REQUIRED`, or reasons containing `confirm your age`, `age-restricted`, or `inappropriate`) map to `AgeRestricted`; a reason containing `private` maps to `Private`; generic bot checks stay `Unknown`.
- `ERROR` must not map to `AgeRestricted`, even if its reason contains `inappropriate`; deleted/unavailable videos must remain `Unavailable`. `sponsors_only_video` in `errorScreen.playerLegacyDesktopYpcOfferRenderer.offerId` identifies `MembersOnly`. `OK` maps to `Public`; unmatched states stay `Unknown`.
- `AgeRestricted` means the page indicates an age gate, not that the video is gone or membership is established. In StreamRecordTools, `IsMemberOnly` still asks the comment API; automatic membership discovery must not skip this state because an age gate can hide the membership signal. Public age-gated videos are skipped when the comment API succeeds.
- StreamRecordTools' daily unarchived-file check treats `AgeRestricted` as still accessible and does not move it. Bot probe-video setup accepts it and leaves membership decisions to the comment API. See [[bot-youtube-member-authorization]].
- Known risks from the 2026-11-14 review: StreamRecordTools may move a still-valid video when the Data API omits it and the page returns `Unknown` (including a bot check). Bot periodic membership checks also leave an age-restricted probe on the API path; the reviewer flagged a possible false-member result if comments are readable, but this was not verified against a real probe.
