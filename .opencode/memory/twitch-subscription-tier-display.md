# Twitch subscription tier display

- System-generated Traditional Chinese labels and reply text must not use English `Tier` or display provider codes.
- General wording uses `訂閱層級` or `層級身分組`; levels 1000/2000/3000 display as `層級 1` / `層級 2` / `層級 3`.
- Frontend tier role entries each render on their own line, not concatenated.
- Discord role names are data: the frontend must show them verbatim and must not replace `Tier 1/2/3` inside a role name. The Bot keeps existing role naming rules when creating or repairing roles; wording changes do not rename roles.
- Bot wording: Traditional Chinese uses `層級`, Japanese uses `ティア`, English keeps `Tier`.
- Internal API, database, and metrics tier fields plus raw 1000/2000/3000 codes stay unchanged.
- Applied and verified on frontend and Bot on 2026-08-17. Role-name conversion was reverted so names display verbatim.
- Bot display helper is `TwitchSubscription.FormatTier(tier, locale)`: 1000/2000/3000 -> `Tier 1/2/3`, `ティア 1/2/3`, `層級 1/2/3`; unknown tier -> localized `Unknown`/`不明`/`未知`. Raw codes and DB/API fields stay unchanged.
- Bot auto-recreates a Twitch subscription tier role that was deleted in Discord and updates the database accordingly (2026-11-07). Role naming rules and verbatim display are unchanged.
- Verification and role sync use stored Discord role IDs, not role names; tier role names are normalized by `EnsureTierRoleNameAsync` to `<subscriber role name> Tier N` during setup/repair, so manual renames of tier roles can be overwritten.
- Related: [[frontend-settings-page]], [[bot-admin-settings-service]], [[twitch-subscription-commands]].