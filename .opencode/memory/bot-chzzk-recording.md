---
name: CHZZK recording integration
description: CHZZK recording delegation between Bot and StreamRecordTools
---
# CHZZK 錄影整合（Bot + StreamRecordTools）

CHZZK 錄影由 Scraper 偵測新場次時委派到外部 StreamRecordTools，沿用 Twitch／TwitCasting 的 Redis channel 契約，不經通知發送流程。計畫文件：`docs/CHZZK_RECORDING_PLAN.md`（已實作，未 commit 狀態見 transcript）。

## 資料庫

- `ChzzkSpider` 新增 `is_record` tinyint(1) NOT NULL DEFAULT FALSE，migration `20260918070419_AddChzzkAutoRecord`，由 [[bot-startup-database-migrations]] 套用；舊 `migrate_sql/all.sql` 已刪除。
- 只加 `IsRecord` 開關，預設關閉；不加啟用時間欄位。

## Redis 契約

- Channel `chzzk.record`（StreamRecordTools 訂閱；Bot 端發布）。
- Payload JSON `{ "channelId": "...", "streamKey": "channelId:yyyyMMdd_HHmmss" }`（Newtonsoft）。
- StreamRecordTools `Subscribe.cs` 解析後派工 `chzzk_once`。

## StreamRecordTools

- CLI verb `chzzk_once <channelId> <streamKey>`，分派到 `Chzzk.StartRecord`。
- `ToolConfig.ChzzkRecordPath`（預設 `./chzzk_record`），`.env`/`docker-compose.yml` 掛載對應。
- `Command/Record/Chzzk.cs`：Streamlink 錄 `https://chzzk.naver.com/live/{channelId}`，先寫暫存再搬到保存目錄；退出碼與檔案大小決定 `Completed`/`Partial`/`Failed`。
- 頻道層級 Redis 執行鎖（`LockTake`/`LockExtend`/`LockRelease`），TTL 60s、續租 20s，同頻道同時只跑一份 Streamlink；Redis 中斷視為失去鎖並停止錄影。
- 驗證：channelId 32 位十六進位、streamKey `channelId:yyyyMMdd_HHmmss`。

## Bot 端

- `SharedService.Chzzk.ChzzkRecordService`：`SetAutoRecordAsync(channelId, enabled, ct)` 明確設定；`ToggleAutoRecordAsync(channelId, ct)` 反轉；共用 `ApplyAutoRecordAsync`。
- `ChzzkSpider.IsRecord` 讀寫；爬蟲不存在回 `record.not-configured`。
- Scraper：新 CHZZK 場次且 `spider.IsRecord` 時發布 `chzzk.record`（channelId + streamKey）；既有場次接回／PendingClose 取消／重啟不補錄。
- 前綴指令：`s!ChzzkRecord`（立即）、`s!ChzzkAutoRecord`（on/off）、`s!ChzzkRecordList`。
- `CrawlerOwnerNotifier`：CHZZK 分支單一按鈕「切換自動錄影」`spider_chzzk:record:{id}`；YouTube 分支兩個切換鈕 `spider_youtube:trusted:{id}`、`spider_youtube:record:{id}`。
- `SpiderManagementComponent`：`HandleChzzkAsync` 呼叫 `ToggleAutoRecordAsync`，確認訊息用 `Spider.RecordingChanged`；`HandleYoutubeAsync` 切換 `IsTrustedChannel` 與 `RecordYoutubeChannel` 存在與否。舊 `untrusted`/`unrecord` custom id 因 `Contains("trusted"/"record")` 仍走切換。
- CancellationToken 使用 `GracefulShutdown.Token`。

## 已取消的設計（不可依此實作）

啟用時間欄位、每輪 OPEN 補送、錄影端恢復後自動補錄、全域開關、停止單場、即時狀態、網站設定、自動補送 — 全部取消。

## 驗證

Release build 0 警告；測試 717 passed / 39 skipped（含 `AdminSettingsContractTests`、`CrawlerOwnerNotifierTests`）。未實際啟動 Scraper/Notifier/StreamRecordTools 端對端驗證。
