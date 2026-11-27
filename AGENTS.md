# 工作區說明

這個工作區是一個 meta repo，五個子 repo 以 Git submodule 掛載。執行指令、檢查差異與提交時，必須進入正確的子目錄，不要把工作區當成同一個儲存庫。submodule 只記錄各子 repo 的 commit；子 repo 的改動仍要在子目錄內自行 commit。

| 使用者提到的範圍 | 目錄 |
|---|---|
| Bot、機器人，或未特別指定 | `DiscordStreamNotifyBot` |
| 後端、API、OAuth | `DiscordStreamBotBackend` |
| 前端、網站、管理介面 | `discord-stream-bot-frontend` |
| 錄影工具 | `StreamRecordTools` |
| YouTube issue 巡檢工具 | `YouTubeIssueMonitor` |

## 子模組指標同步

子 repo 完成 commit／合併／push 後，回工作區根目錄把子模組指標一起 commit，不要讓 `git status` 留著 modified submodule：

```sh
git add <子目錄>
git commit -m "chore(workspace): 更新子 repo 版本"
```

多個子 repo 一起更新時合成一個 commit。需要推工作區時再 `git push origin master`。

跨專案修改前，先確認共享契約的實際擁有者：

- MySQL schema 與 migration 由 Bot 儲存庫管理。
- Bot 與 Backend 共用 OAuth token 加密格式及 `ProviderTokenEncryptionKey`。
- Bot、Backend 與錄影工具透過既有 Redis channel 交換事件；不可只改其中一端。
- Frontend 與 Backend 共用 OAuth callback、API 路徑及管理設定 JSON 契約。

公開 README 應以新使用者能自行安裝與部署為準。不要寫入個人主機路徑、私人網域、單次遷移步驟或只有目前維護者才知道的前置條件。

## 工具腳本

`.bat` 檔一律只用 ASCII。cmd 用系統 OEM 代碼頁解析 batch 檔本身，`chcp 65001` 改不到它；檔案裡出現中文 `rem` 或註解會讓整段指令被拆壞。中文說明放 `.md`。

## 專案狀態：已上線

這個專案有真實使用者。全域 AGENTS.md 的 "Ground rules"、"Every change, in this order"、"Keep old code just in case" 在這裡不適用。

改動時：
- 保持向下相容：公開 API、資料庫 schema、設定檔鍵名、訊息格式改了以後，舊的用戶端和舊資料還要能用。做不到相容就先問我。
- 改 schema 一定要寫 migration，不要直接改資料庫。migration 要能回退。
- 刪程式碼前，先確認沒有外部呼叫端（其他服務、排程、舊版前端）。
- 正式環境的資料、設定、部署：只讀，要改先問我。