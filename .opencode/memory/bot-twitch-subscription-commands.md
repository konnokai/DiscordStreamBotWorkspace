# Bot Twitch subscription commands

- Slash command groups were renamed: `/twitch-member` -> `/twitch-subscription`, and `/twitch-member-set` -> `/twitch-subscription-set`. Leaf command names are unchanged.
- Internal namespace and module classes moved from `Interaction.TwitchMember` to `Interaction.TwitchSubscription` (`TwitchSubscription`, `TwitchSubscriptionSetting`, `TwitchSubscriptionComponent`); files now live under `Interaction/TwitchSubscription/`.
- Interaction component custom id `twitch-member-check:*:*` was intentionally left unchanged; it is an internal route, not a slash command name.
- Localization message keys were not renamed: code and resx still use `TwitchMember.*` and `TwitchMemberSetting.*`.
- Slash group localization keys in `InteractionCommands.*.resx` were renamed to `twitch-subscription.*` and `twitch-subscription-set.*`.
- The readable command contract snapshot and `InteractionCommandContractTests` were updated for the new group names.
- Guild config field `LogMemberStatusChannelId` was renamed to `VerificationLogChannelId` (shared by YouTube and Twitch verification); EF model snapshot column is `verification_log_channel_id`. No migration was added; the production DB column must be renamed manually by the owner.
- `Administration.GuildInfo` now prints Twitch subscription configs as `BroadcasterDisplayName: SubscriberRoleId` alongside the existing YouTube member and Twitch spider lines; the verification log channel label changed to "伺服器會員驗證記錄頻道".
- Verification: Release build 0 warnings/errors; 563 tests passed, 36 environment tests skipped; EF `has-pending-model-changes` reported no changes; `git diff --check` passed.
- Related: [[twitch-subscription-tier-display]], [[web-admin-settings-center]], [[bot-twitch-subscription-reverification]].