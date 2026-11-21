# Bot YouTube scraper schedule detection

- Scraper `YoutubeDetectionService.OtherScheduleAsync` parses `/streams` page `ytInitialData` to discover scheduled streams.
- YouTube's `/streams` response still has `ytInitialData`, but video entries moved from `gridVideoRenderer`/`videoRenderer` to `richItemRenderer`/`lockupViewModel`; video IDs now live at `richItemRenderer.content.videoRenderer.navigationEndpoint.watchEndpoint.videoId` or `richItemRenderer.watchEndpoint.videoId`.
- `Schedule.cs` regex match must be checked before `JObject.Parse`; an unmatched regex leaves an empty string and throws `Newtonsoft.Json.JsonReaderException: Path '', line 0, position 0`.
- HTTP status and response state should be logged for failed parses; Polly retry remains in place. Status as of 2026-11-07 transcripts: fix requested and being implemented, tests to be run.