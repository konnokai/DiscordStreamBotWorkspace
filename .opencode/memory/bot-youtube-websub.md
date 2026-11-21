# Bot YouTube WebSub contract

- YouTube push 通知的 canonical topic URL 使用 `https://www.youtube.com/xml/feeds/videos.xml?channel_id=...`，不是文件上的 `/feeds/videos.xml`。Hub 只對 `/xml/feeds/` 版本推送，程式碼已固定此前綴。
- 相關程式碼：`DiscordStreamNotifyBot.Shared/SharedService/Youtube/YoutubeWebSubContract.cs`（`YoutubeWebSubContract`、`ClassifyStatus`）。
- 對應上游 issue 566069563 已標記 covered，不需修改。
"