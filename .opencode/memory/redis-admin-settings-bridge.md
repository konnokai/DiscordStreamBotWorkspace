# Redis admin settings bridge

- `AdminSettingsRedisService` bridges Backend to the Notifier.
- `GetInstalledGuildIdsAsync` reads Redis DB 0 hash `cluster:stats:guild_snapshot` and parses both legacy array and `{guilds:[{id}]}` envelope shapes.
- `RequestSnapshotAsync` and `SendCommandAsync` publish to the snapshot/command request channels and wait on `admin:settings:reply:{correlationId}`.
- `PublishAndWaitAsync` subscribes before publishing, so a fast owning-shard reply is not lost.
- The service intentionally returns null on no subscriber, timeout, cancellation, or bridge failure. Backend controller parsers reject null/whitespace before deserialization so the failure stays a stable `settings.unavailable` response instead of a 500.