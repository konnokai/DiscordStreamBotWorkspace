# Backend Discord OAuth session

- Discord OAuth session payload retains the encrypted opaque Discord access token and provider expiry; the plaintext token is never exposed to the frontend.
- Session expiry is the earlier of the existing 12-hour lifetime and Discord `expires_in`; refresh tokens are not stored.
- Existing account-link authentication by Discord user ID keeps working.
- Admin controllers can retrieve a valid Discord session including the access token.
- Discord OAuth scope expanded from `identify` to `identify guilds`.