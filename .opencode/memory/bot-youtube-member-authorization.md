---
name: Bot YouTube member authorization
description: YouTube member OAuth, Brand Account behavior, and authorization pitfalls.
---

# Bot YouTube member authorization

- 會員驗證流程：Backend 取得 Google OAuth provider token，Bot 以 `channels.list(mine=true)` 取得連結頻道，再以 `commentThreads.list` 探測會員留言。呼叫面見 [[bot-youtube-api-surface]]。
- Brand Account 授權可能出現 `channels.list(mine=true)` 回傳 0 筆或 HTTP 401 `youtubeSignupRequired`；Google 指出 Studio 委派頻道要用 `managedByMe=true` 列舉，OAuth URL 可加 `enable_yt_permissions=true` 啟用新 Studio 權限選擇器。
- 目前程式碼將所有 401 視為 `AuthorizationInvalid`，會清除 token 並移除會員角色；Brand Account 的 `youtubeSignupRequired` 可能誤判仍有效授權。`mine=true` 回 0 筆目前仍通過授權驗證，後續留言探測可能誤判為非會員。
- 2026-11-08：issue 582914627 的頻道移轉案例被判為 covered，因為沒有新的 Google 回覆或 API 契約，且當時的任務 `576452668:mine-empty-zero-channel`、`568009414:brand-account-mine-empty` 已涵蓋 `mine=true` 空結果。不要只憑這個舊案例新增重複任務。
- 截至 2026-11-18，Issue Tracker 585873688 仍待驗證：Google 在 2026-11-16 將剛移轉的 Brand Account 空清單回應歸因於 Data API 索引延遲，建議等待 24–48 小時後重新授權；回覆沒有確認後續 `commentThreads.list` 的結果。原任務 `585873688:mine-true-empty-items-unconfirmed-identity` / `mine-true-empty-items-v1` 沿用，待以測試 Brand Account token 記錄留言探測的 HTTP 狀態與 reason。
- OAuth 同意畫面需為 In production，避免 refresh token 7 天過期。
- `commentThreads.list` 偶發 forbidden 的舊回報（issue 112448133）維護者判定過舊，不再追蹤。
- 相關程式碼：`DiscordStreamBotBackend/Services/GoogleOAuthService.cs`（`GetAuthorizationUrl`、`GetChannelAsync`）、`DiscordStreamNotifyBot.Notifier/SharedService/YoutubeMember/YoutubeMemberApiClient.cs`（`ValidateAuthorizationAsync`、`Classify`）、`YoutubeMemberAuthorizationService.cs`（`GetLinkedChannelAsync`）、`CheckMemberShip.cs`。
- 2026-08-05 production-shaped rehearsal: migration + rollback applied to MariaDB 10.11 with representative legacy data; checked-in incremental SQL ran twice with single migration-history row; Bot Docker SIGTERM drained tracked events and exited 0 within 1s (30s stop grace unused). Plan doc `docs/YOUTUBE_MEMBER_VERIFICATION_REFACTOR_PLAN.md` marked rehearsal done; real Discord/Google acceptance still pending.
