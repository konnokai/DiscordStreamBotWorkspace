# Frontend settings page

- Route `/settings` uses the existing manual path routing in `App.vue`; no vue-router.
- Discord OAuth scope expanded from `identify` to `identify guilds`.
- Manageable guilds load from `/admin/guilds`; installed guilds sort first, then by name.
- Desktop layout uses a 280px independently scrollable guild sidebar; mobile uses a horizontally scrollable guild strip without page overflow.
- Settings tabs: general, YouTube, Twitch, TwitCasting.
- When `botInstalled=false`, show invite/help and do not load settings.
- Existing YouTube notifications display readonly `sourceName` instead of an editable source ID.
- Settings fetch uses `AbortController`: `getGuildSettings(apiURL, token, guildId, signal?)` accepts an optional `AbortSignal`; `loadSettings` aborts the previous request, and stale responses cannot overwrite newer state. `selectGuild` and unmount also abort.
- Settings loading area shows an indeterminate progress bar (`.settings-progress`) with `role="status"`/`role="progressbar"`; reduced motion disables animation.
- Backend keeps the manageable-guild list cached for the Discord session while refreshing `botInstalled` from Redis on every `/admin/guilds`. Design: frontend auto-refreshes the guild list on `window focus`/`visibilitychange` after Discord invite, keeps the manual refresh button, and only bypasses cache for newly created guilds.
- Settings navigation changed from a single tab bar to a main menu (general/notifications/crawler/verification) with a platform sub-menu for the three platforms; crawler/verification forms are functional, not preview-only.
- Frontend now types `crawlers`, `verification`, and `resources.roles`; `activeCrawler`/`activeVerification` computed views, `roleName`/`tierRoleNames` helpers, and probe-video inputs.
- Mutations: per-form pending state (Set of form keys) instead of one page-wide lock; only the submitting form's button shows "儲存中…" and is disabled, other forms stay usable. `applied` does not trigger a full `GET /settings` reload for existing items; the local snapshot is updated optimistically and remove deletes locally. New crawler/notification items reload only to fetch backend-filled source name/detection status. `rejected`/`unknown`/`timeout` keep user input and show a reload button; no optimistic success. General settings only sends changed fields (locale/notice/log channel). Stale replies from a previous guild are ignored via `guildSelectionVersion`. `AdminMutationReply.code` is preserved and surfaced for specific rejection messages. `removeCrawler`/`removeVerification` confirm first.
- Wide general-settings layout: each `<label>` owns its select, restoring three aligned complete fields instead of interleaving labels/controls as separate grid items.
- YouTube forms (existing and new) place the "create Discord scheduled event" checkbox after all six message fields.
- Discord OAuth stores the initiating same-origin path in `sessionStorage`; after successful root callback token exchange, `DiscordSection` validates it as a local path and `location.replace` returns directly to `/settings`.
- Footer/sidebar height: `.settings-sidebar` uses `lg:h-[calc(100vh-3.5rem)]` (not `100vh-7rem`), so the sticky sidebar no longer leaves a footer-height black gap; page min-height still reserves footer space.
- Per-form `aria-busy` on forms and spinner inside buttons; `hasPendingMutations` blocks only global reload/select. Verified: `pnpm build`, `pnpm lint:script`, `pnpm lint:style`, Prettier, `git diff --check`; formal browser desktop/mobile acceptance still pending.