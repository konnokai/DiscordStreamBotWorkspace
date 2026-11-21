---
name: Database schema ownership
description: MySQL schema ownership and the Bot/Backend database boundary
---
# Database schema ownership

- MySQL schema and migrations are owned by the Bot repo.
- Backend only maps the existing schema and does not create or update tables.
- Shared tables include `GuildConfig`, `Notice*StreamChannel`, `GuildYoutubeMemberConfig`, and `GuildTwitchSubscriptionConfig`.
- `GuildConfig.LogMemberStatusChannelId` was renamed to `VerificationLogChannelId` (shared YouTube + Twitch verification log channel); EF model and snapshot now use `verification_log_channel_id`. Historical migrations were not regenerated, so the production column rename is manual; do not add a migration for this rename in the normal flow.
- Bot startup migration behavior is documented in [[bot-startup-database-migrations]].
