---
name: TwitCasting Webhook 404 semantics
description: Webhook registration 404 cleanup behavior and its verification limits.
---

# TwitCasting Webhook 404 semantics

- TwitCasting API v2 documents `404 Not Found` generically as content not found. The `POST /webhooks` error list does not say that a 404 specifically means the user account was deleted.
- A reported channel page redirecting to the home page is not verified API evidence. A registration 404 is also not definitive proof of account deletion; treat automatic cleanup as a risk-based operational choice, not as an API guarantee.
- **Current implementation (2026-11-15):** cleanup runs when reconciliation plans `RegisterLiveStart`. Any HTTP 404 from `POST /webhooks` is classified as `UserNotFound`, regardless of body shape; the first 200 body characters are logged. The 404 IDs are collected and cleaned up after webhook reconciliation.
- If more than 3 IDs return 404 and that count exceeds 10% of the distinct, nonblank spider channel IDs, Scraper calls `GET /users/{id}` for each and cleans only IDs confirmed absent. If none are confirmed absent, cleanup is skipped. For batches not crossing that threshold—including up to 3 IDs—registration 404s are trusted directly. This leaves a residual risk that a transient or service-wide 404 can remove up to 3 records without secondary confirmation, including every record in a small deployment.
- For cleanup, Scraper publishes `twitcasting_spider_removed` before deletion. The event carries associated `GuildIds`; Notifier sends one owner DM from shard 0. It deletes only snapshot row IDs via `ExecuteDeleteAsync`, so later rows for the same channel are not silently removed without appearing in the notification. Notification settings remain.
- The dedup key is `twitcasting:spider_removed:{ChannelId}:{minimum snapshot row Id}` with a one-day TTL. Including the row ID allows a later re-added spider to receive a new notification. Delete failures leave rows for retry; publish failures also leave rows. Duplicate notifications are suppressed during retry, but the one-day TTL means a retry lasting longer than a day can send another DM.
- Deploy Notifier before Scraper when adding this bus type. Older Notifier versions ACK unknown types, so the reverse order can lose the owner notification.
- This cleanup does not detect a dead channel whose webhook is already registered, because only planned registration actions trigger the check.
- The 2026-11-15 fix was merged and pushed to `master` as `5816827`. Release build succeeded with 0 warnings and 0 errors. No live 404, Redis, or multi-shard integration test was run.
