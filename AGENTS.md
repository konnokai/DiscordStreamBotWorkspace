# 工作區說明

這個工作區是一個 meta repo，五個子 repo 以 Git submodule 掛載。執行指令、檢查差異與提交時，必須進入正確的子目錄，不要把工作區當成同一個儲存庫。submodule 只記錄各子 repo 的 commit；子 repo 的改動仍要在子目錄內自行 commit。

| 使用者提到的範圍 | 目錄 |
|---|---|
| Bot、機器人，或未特別指定 | `DiscordStreamNotifyBot` |
| 後端、API、OAuth | `DiscordStreamBotBackend` |
| 前端、網站、管理介面 | `discord-stream-bot-frontend` |
| 錄影工具 | `StreamRecordTools` |
| YouTube issue 巡檢工具 | `YouTubeIssueMonitor` |

跨專案修改前，先確認共享契約的實際擁有者：

- MySQL schema 與 migration 由 Bot 儲存庫管理。
- Bot 與 Backend 共用 OAuth token 加密格式及 `ProviderTokenEncryptionKey`。
- Bot、Backend 與錄影工具透過既有 Redis channel 交換事件；不可只改其中一端。
- Frontend 與 Backend 共用 OAuth callback、API 路徑及管理設定 JSON 契約。

公開 README 應以新使用者能自行安裝與部署為準。不要寫入個人主機路徑、私人網域、單次遷移步驟或只有目前維護者才知道的前置條件。

## codebase-memory-mcp

索引以本工作區為根，一個 project 涵蓋全部儲存庫；各儲存庫另有自己的 project。

- 查跨儲存庫關係用 `E-repos-_konnokai-Discord-DiscordStreamNotifyBot`，查單一儲存庫細節用該儲存庫的 project。一次只用一邊，混用會看到重複結果。
- 要引用圖譜結果前先跑一次 `index_repository`；不要假設背景 watch 已經重建（未實測）。

### 圖譜查不到，必須 grep

| 目標 | 原因 |
|---|---|
| MySQL 表名、欄位 | migration 的表名是 C# 字串；全圖譜只有 1 個 `Table` 節點，實際有 33 次 `CreateTable` |
| 翻譯 key、`.resx` 內容 | 6 個 resx 只解析出 `root`、`data`、`value` 等假節點，沒有 key |
| Redis channel 名、環境變數、API URL | 都是字串常數，沒有符號可連 |
| Vue `<template>` 的綁定、class、component 用法 | 只索引 `<script setup>`，template 與 style 不解析 |

### 樹狀解析不完整的檔案

| 檔案 | 可能缺漏的行 |
|---|---|
| `DiscordStreamBotBackend/Dockerfile` | 10-28 |
| `DiscordStreamNotifyBot/Dockerfile` | 22-24 |
| `DiscordStreamNotifyBot/src/DiscordStreamNotifyBot.Shared/Migrations/_Baseline_ExistingDb.sql` | 14-17 |
| `discord-stream-bot-frontend/src/index.css` | 9 |

### 不要信這幾種圖譜輸出

- `get_architecture` 的 `routes`：會把日期格式字串（`yyyy-MM-dd'T'HH:mm:ss.fff'Z'`）誤判成路由，`method` 欄位全空。API 契約要讀 Backend controller 與 `discord-stream-bot-frontend/src/lib/`。
- 註解的 `MENTIONS` 邊：圖譜自報 204 條，82 條 missing、120 條 ambiguous。註解寫的行號要開檔確認。
- `cross-repo-intelligence` 的結果：跨儲存庫沒有任何 `ProjectReference`，共用契約都是字串，所以跨 repo 邊恆為 0。這不是索引失敗。
- `bin`、`obj`、`.vs`、`.git`、`.opencode/memory/sessions` 不在索引內，build 產物與 EF generated snapshot 查不到。

## 專案狀態：已上線

這個專案有真實使用者。全域 AGENTS.md 的 "Ground rules"、"Every change, in this order"、"Keep old code just in case" 在這裡不適用。

改動時：
- 保持向下相容：公開 API、資料庫 schema、設定檔鍵名、訊息格式改了以後，舊的用戶端和舊資料還要能用。做不到相容就先問我。
- 改 schema 一定要寫 migration，不要直接改資料庫。migration 要能回退。
- 刪程式碼前，先確認沒有外部呼叫端（其他服務、排程、舊版前端）。
- 正式環境的資料、設定、部署：只讀，要改先問我。