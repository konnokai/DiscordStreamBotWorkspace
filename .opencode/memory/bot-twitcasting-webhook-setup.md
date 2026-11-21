---
name: TwitCasting Webhook setup
description: Application settings and Bot-to-Backend flow required for TwitCasting live-start webhooks.
---

# TwitCasting Webhook setup

- TwitCasting API v2 requires a Webhook URL on the application before `POST /webhooks` can register a channel. Configure `https://<backend-host>/TwitCastingWebHook`; the endpoint must respond directly because TwitCasting does not follow 30x redirects. The Backend currently returns 204. Source: [API v2 docs](https://apiv2-doc.twitcasting.tv/).
- The Bot needs `TwitCastingClientId` and `TwitCastingClientSecret` to authenticate its API requests. The Backend validates the incoming payload's `signature` against `TwitCasting:WebHookSignature`; a mismatch returns 401. Never store the values here.
- Scraper reconciles registrations every 15 minutes and registers the `livestart` event for monitored channels. After replacing the application credentials, restart Scraper and let reconciliation restore registrations; no manual `POST /webhooks` is needed.
- The Backend publishes accepted live-start payloads on `twitcasting.pubsub.startlive`, which Scraper consumes. Keep both sides aligned; see [[bot-twitcasting-webhook-404]].
- The developer form's exact required fields were not verified while logged in. Bot webhook delivery does not use TwitCasting's OAuth callback flow.
