# Backend admin guild authorization

- Authorization uses `GET https://discord.com/api/v10/users/@me/guilds` with the user access token.
- IDs and permissions are strings. A guild qualifies when `owner=true` or permissions contains the `ADMINISTRATOR` bit 8.
- Every admin GET/POST revalidates against Discord; authorization is never derived from a Redis snapshot alone.
- Endpoints:
  - `GET /admin/guilds`: manageable guilds with `id`, `name`, `icon`, `owner`, `permissions`, `botInstalled`. `botInstalled` comes from Redis DB 0 hash `cluster:stats:guild_snapshot`; legacy array/envelope shapes are tolerated.
  - `GET /admin/guilds/{guildId}/settings`: authorize, then publish a snapshot request.
  - `POST /admin/guilds/{guildId}/commands` with body `{action,payload}`: authorize, generate a version-1 envelope, publish directly, await the correlation reply, and return it.
- Admin mutations use direct Redis publish/subscribe, not `RedisService.AddPubMessageAsync` or its retry queue. Subscribe before publishing. A non-subscriber or missing owning reply returns a stable unavailable/unknown response without retrying the mutation. Use the request `CancellationToken`.
- `GET /admin/guilds` caches Discord manageable-guild results in process memory for the lifetime of the current Discord session. Cache key is `(DiscordGuildAuthorizationService type, Discord user ID, session issued-at UTC)`; access tokens are never cache keys. Cache expires at session expiry or relogin.
- Only `GET /admin/guilds` uses cache; settings and command authorization still call Discord live to avoid stale privileges authorizing mutations.
- Cached `AdminGuild` DTOs are cloned because the controller adds `BotInstalled` from current Redis state; `BotInstalled` therefore reflects the latest install status even while the guild list is cached.
- Added focused cache test; 74/74 backend tests passed and Release build succeeded on 2026-08-13. Changes were uncommitted in a dirty worktree.
- 2026-08-17 admin settings command 500 fix: `AdminSettingsRedisService` intentionally returns null on no subscriber, timeout, cancellation, or bridge failure. `TryReadSnapshotReply`/`TryReadCommandReply` now reject null/whitespace before Newtonsoft deserialization, avoiding `ArgumentNullException` outside the `JsonException` catch and preserving the 503 `settings.unavailable` response. Added `MissingAdminSettingsRepliesAreRejected`. Verification: focused `AdminSettingsContractTests` 15/15 and full backend 76/76 passed in Release.