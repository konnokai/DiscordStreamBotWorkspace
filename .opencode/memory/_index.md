# Memory index

## architecture
- [[web-admin-settings-center]] — Cross-repo web admin settings center plan, boundaries, contract

## backend
- [[backend-discord-oauth-session]] — Discord OAuth session retains encrypted provider token
- [[backend-admin-guild-authorization]] — Guild authorization and admin endpoints
- [[redis-admin-settings-bridge]] — Backend-to-Notifier Redis bridge
- [[shared-oauth-token-encryption]] — Shared OAuth token key handling

## frontend
- [[frontend-settings-page]] — /settings SPA implementation and layout
- [[frontend-discord-oauth-loading]] — Discord OAuth callback blocking overlay
- [[twitch-subscription-tier-display]] — Twitch subscription tier wording and role-name display rules

## observability
- [[grafana-coordinator-dashboard]] — Coordinator dashboard counter panels use interval event counts
- [[grafana-loki-log-dashboard]] — Importable Grafana 10 Loki log dashboard and live verification

## bot
- [[bot-admin-settings-service]] — Notifier admin settings snapshot/command service
- [[bot-localization]] — Bot three-language localization and terminology rules
- [[bot-test-project]] — xUnit project validating InteractionCommands resx descriptions
- [[bot-twitcasting-webhook-404]] — TwitCasting Webhook 404 cleanup behavior and verification limits
- [[bot-twitch-stream-detection]] — Twitch offline confirmation and false StartStream prevention
- [[bot-twitch-subscription-commands]] — Twitch subscription slash command rename and localization contract
- [[bot-twitch-subscription-reverification]] — Hourly Twitch subscription re-verification cycle, locking, rate limits
- [[bot-youtube-member-authorization]] — YouTube member authorization, Brand Account OAuth pitfalls
- [[bot-youtube-api-surface]] — Bot YouTube Data API call paths observed in the 2026-11-21 source scan
- [[bot-youtube-video-page-status]] — YouTube watch-page status classification and cross-repo caller behavior
- [[bot-youtube-websub]] — YouTube WebSub canonical topic URL contract
- [[bot-youtube-scraper-schedule]] — YouTube /streams ytInitialData parsing and richItemRenderer support
- [[bot-twitcasting-webhook-setup]] — TwitCasting application settings, Bot credentials, and live-start webhook flow
- [[bot-onboarding]] — Missing notification channel onboarding check
- [[bot-chzzk-recording]] — CHZZK recording delegation to StreamRecordTools, Redis channel, lock, toggles
- [[database-schema-ownership]] — MySQL schema and migration ownership
- [[bot-startup-database-migrations]] — Startup migration flow, deployment review, and legacy database constraints

## tooling
- [[youtube-issue-monitor-input-shape]] — Nested issue fields in YouTube Issue Monitor input.json
- [[graphify-query-guidance]] — Explicit repository selection and broad-query truncation
