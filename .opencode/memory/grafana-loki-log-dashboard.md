# Grafana Loki log dashboard

- File: `DiscordStreamNotifyBot/deploy/grafana/dashboards/logs-loki.json` (uid `discord-stream-logs`), Grafana 10 importable, Loki datasource input `DS_LOKI`.
- Uses only the four fixed labels (`app`, `service`, `role`, `level`); does not bind Serilog JSON body fields. Panels: filtered count, ERROR/CRITICAL count, level traffic, errors by role, raw structured logs.
- Variables: `service`, `role`, `level`, `search` (content regex). `search` defaults to empty string to avoid Grafana highlighting the whole message; LogQL uses `|~ ""`.
- Logs query includes `| json | line_format "{{.Message}}"` so the visible line is `Message` while expanded structured fields remain available.
- Live-verified against Loki 3.4.2 at `http://192.168.98.21:3100`: `/ready` 200 after transient 503; labels/values match contract (`app=discord-stream-notify-bot`, service coordinator/notifier/scraper, role coordinator/notifier:0/notifier:1/scraper, level INFO/WARN/ERROR); all five query forms succeeded (6h total/error counts, errors by role, level series, filtered logs). At verification time: 5356 logs / 5 errors, all errors grouped under scraper.
- `docs/LOGGING.md` documents import steps. jq JSON/structure checks and `git diff --check` passed. Dashboard remains uncommitted. Existing imported dashboards must clear Content Regex or re-import.
- See also [[grafana-coordinator-dashboard]].