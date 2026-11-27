---
name: yt-dlp YouTube challenge and image
description: YouTube n-challenge failure diagnosis and the StreamRecordTools base-image update known on 2026-11-27.
---

# yt-dlp YouTube challenge and image

- On 2026-11-27, `a.addOnDisposeCallback is not a function` during YouTube n-challenge solving matched an upstream yt-dlp player-JS compatibility bug, not a Deno-only or PO-token failure. yt-dlp 2026.11.23 changed the default `player_js_variant` from `main` to `tv`; the bashonly SABR branch included that fix at commit `1ded8c3`.
- On 2026-11-27, `StreamRecordTools/Dockerfile` was updated to `jun112561/dotnet_with_yt-dlp:sabr-2026.11.23-1ded8c3`. The code change reached `StreamRecordTools/master` as merge commit `45737cd`. Recheck newer tags before relying on this dated version.
- `dotnet_with_yt-dlp/build.sh [stable|sabr]` builds the PyPI stable package or the bashonly SABR branch and tags the image from yt-dlp's version plus the SABR branch's short commit. Updating the base image does not update an already deployed `jun112561/stream-record-tools:master`; rebuild and publish that image too.
- The tag was supplied as already built by the user. Docker was unavailable in the 2026-11-27 session, so that session did not build or smoke-test the image locally.
- No-format notification checks deliberately exclude n-challenge warnings because some formats, including SABR, may still work. See [[youtube-start-notification-fallback]] and [[youtube-ytdlp-error-owner-dm]].
