# Shared OAuth token encryption

- Bot and Backend share OAuth token encryption format and the key named `ProviderTokenEncryptionKey`.
- Do not rotate `ProviderTokenEncryptionKey` when rotating the frontend session token; otherwise existing provider tokens cannot be decrypted.
- The frontend session token (`Token:Frontend`) is separate and can be rotated to invalidate historical long-lived DT.
- The OAuth contract and frontend domain switch are breaking: deploy Backend, Cloudflare Pages Frontend, and Bot link settings together in a maintenance window.
- On deploy, rotate `Token:Frontend`; do not rotate `ProviderTokenEncryptionKey`, or existing provider tokens cannot be decrypted.
- Backend reads only the provider-token key field; complete the key-field rename in one deploy to avoid two key sources.
- Shared OAuth/member-verification tables are migrated by the Bot repo; Backend only maps the existing schema and does not create/update tables. Apply Bot repo migration SQL before deploying Backend.