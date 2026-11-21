# Frontend Discord OAuth loading overlay

- `DiscordSection.vue` shows a Teleport-to-body full-page blocking overlay while `POST /oauth/discord/callback` is pending.
- Overlay uses z-index 100 (above header 50), an indeterminate progress bar, and Traditional Chinese status text.
- During loading, `#app` gets `inert`, body scroll is locked, and both are restored in `finally` or unmount; `isPageLocked` guards against releasing a lock set by another flow.
- Reduced motion is honored.
- Verified with delayed mocked callback: overlay, inert, scroll lock, accessible status/progressbar, no console errors; `pnpm build`, ESLint, Stylelint, Prettier, and `git diff --check` passed. Uncommitted.