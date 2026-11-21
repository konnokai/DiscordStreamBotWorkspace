---
name: Bot startup database migrations
description: MySQL EF migration startup flow, deployment review, and legacy database constraints
---
# Bot startup database migrations

- As of 2026-11-12, `StartupPreflight.EnsureAsync` applies pending EF migrations for `Scraper` and `Notifier` after MySQL connectivity succeeds. `Coordinator` does not connect to MySQL. Pomelo's `__{database}_EFMigrationsLock` serializes migrations when these processes start together.
- The Bot repo owns the schema; Backend only maps it. Start Bot before Backend. Do not run `dotnet ef database update` against production; Bot startup applies pending migrations.
- Before deployment, generate and review an idempotent script with `dotnet ef migrations script --idempotent --project src/DiscordStreamNotifyBot.Shared`. Keep the output in a temporary location; do not commit SQL scripts. The checked-in `migrate_sql/` directory was removed on 2026-11-12.
- Preserve migration IDs already recorded in production. Do not rename or regenerate them, and do not use `EnsureCreated`. An existing schema without EF migration history must be baselined before starting a build that runs automatic migrations, or EF may try to recreate existing tables. Review destructive changes and old Bot/Backend compatibility; back up before `DROP` changes.
- Validation on 2026-11-12: `dotnet build DiscordStreamNotifyBot.sln -c Release` passed with 0 warnings and 0 errors. A smoke test invoked the startup migration method against an isolated MySQL 8.4 database: a blank database applied 14 migrations and created 28 tables; a second run found no pending migrations. This did not verify production deployment or concurrent startup.

See [[database-schema-ownership]] and [[bot-chzzk-recording]].
