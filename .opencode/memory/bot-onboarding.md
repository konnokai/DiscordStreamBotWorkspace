# Bot onboarding and missing notification channel check

- `TopLevelModule.CheckIsFirstSetNoticeAndSendWarningMessageAsync` checks whether a guild has no YouTube, Twitch, or TwitCasting notice channels and no verification log channel.
- When all are missing, it sends an onboarding embed with command paths for setting the global notice channel and changing language, using the resolved response locale.
- Platform commands already validate channel permissions (ViewChannel, SendMessages, EmbedLinks) before sending notifications.