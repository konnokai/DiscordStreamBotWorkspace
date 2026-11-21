# Grafana coordinator dashboard

- File: `DiscordStreamNotifyBot/deploy/grafana/dashboards/coordinator-prometheus.json`.
- All 15 counter panels formerly using `unit: ops` now use `increase(...[$__rate_interval])`, `unit: short`, `decimals: 0`, with titles changed from "率" to "事件數".
- 4 histogram p95 panels still use `rate()` because p95 requires it.
- Verified against live Grafana: no `ops/s` panels remain; representative panels render integer per-interval counts. Uncommitted.
- Panel 35 `各平台發送成功率` must calculate over the full dashboard range with `increase(...[$__range])`, not recent-point `rate(...[$__rate_interval])`. Do not use zero fallback or `clamp_min`; a zero attempt denominator stays NaN so the Stat panel's `noValue: 無資料` shows. Source dashboard JSON and live panel both updated 2026-11-07.
- Endpoint health panels (Coordinator/Scraper/Backend/Notifier) use `min(up{...})` rather than `max(...)`, so a single down instance marks the service offline.
- Dashboard now includes a Twitch subscription verification row (row 108): verification result rate, role/token/provider failure rates, cycle success rate, p95 duration, and token-rotation/drain status panels. Description updated to mention Twitch subscription verification.