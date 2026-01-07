---
title: "我目前是如何使用 Gemini CLI"
date: 2026-01-08T00:59:21+08:00
tags: [gemini cli, gemini, ai]
---
Gemini CLI 是 Google 於 2025 年 6 月 發佈 出的 AI Agent 工具，有發一篇文章介紹: <https://blog.google/technology/developers/introducing-gemini-cli-open-source-ai-agent/>

在這時間點的前幾個月有出現 Claude Code，Google 也很快的跟上這一波 CLI 的腳步，跟 Claude Code 一樣的，Gemini CLI 把 AI Agent 帶進 terminal，對一些常用 terminal 工作的開發者，可以說是非常的實用。

Gemini CLI 有提供免費額度可以使用，目前使用 Google 帳號登入的額度: 1000 model requests / user / day

寫這篇文章記錄一下到目前為止使用 Gemini CLI 的一些小技巧。

## Prompt Engineering

使用 Gemini CLI 跟其他 AI 工具一樣的， Prompt Engineering 已經是基本功了。我自己的 prompt 也是越寫越長，從短短的一句話，到完整的敘述一個故事，甚至是要準備各式各樣的 prompt 搭配不同的任務來使用。



## 直接看檔案

Gemini CLI 可以在 prompt 裡直接 @ 檔案，AI 會直接讀內容
```markdown
@api.go 新增一個 XX 用途的 API
```

程式碼都會分很多檔案的，所以可以 @ 多個相關的檔案，給 AI 都看過，生成結果會比較接近你的期待。



## 需要 Gemini 記住的準則寫進 GEMINI.md

想要 AI 每次執行指令時都會依照你期待的準則生成結果給你，你可以把這些準則寫進 `GEMINI.md` ，例如程式碼風格、軟體開發準則、最佳實踐、AI 的行為指示等，都可以放進去，AI 就會遵守這些準則生成結果給你


`GEMINI.md` 可以區分生效的範圍
- 想要 AI 每次都遵守的準則就放到全域的 `GEMINI.md` ，檔案位置在`~/.gemini/GEMINI.md`
- 專案獨有的開發準則，就放在專案的資料夾裡的 `GEMINI.md`


另外可以使用指令了解 AI 會看到什麼指示
- `/memory show` 看目前使用的檔案內容 
- `/memory list` 看目前載入的檔案



附上我目前的 `GEMINI.md`
```markdown
# Gemini Global Context

## Behavior

- 必須使用臺灣慣用的繁體中文回答。專業術語請用小括號: () 保留在後面。
- 回答盡量精簡說重點, 避免冗長贅詞。

## Development Principle

- KISS (Keep It Simple, Stupid): 盡可能的保持簡單
- DRY (Don't Repeat Yourself): 避免過多的重複程式碼
- YAGNI (You Aren't Gonna Need It): 只實作目前需要的功能

## Markdown Style

- 少用 emoji
- 避免濫用粗體、斜體

## CODE QUALITY STANDARDS

- Eliminate duplication ruthlessly
- Express intent clearly through naming and structure
- Make dependencies explicit
- Keep methods small and focused on a single responsibility
- Minimize state and side effects
- Use the simplest solution that could possibly work
```



## 常用的 prompt 整理成 custom commands

將常用的 prompt 寫成 custom commands，使用時就不用再寫長長的 prompt，一個簡短的指令就可以叫 AI 開始工作了。

custom commands 的檔案要放在 `~/.gemini/commands/` 這個資料夾底下，使用格式是 TOML。有兩個欄位，一個是 description，放簡短的 command 說明，一個是 prompt，放這個 command 要給 AI 的 prompt。

custom command 有支援一些參數
- {{args}}: 執行 command 時，一起寫進的 prompt
- !{...}: 插入執行 shell 指令的結果到 prompt 中
- @{...}: 插入檔案內容到 prompt 中

除了自己寫之外，可以找別人寫好的 prompt 來使用，分享跟交流可以加快學習腳步。

## 使用 Extension

Extension 是 Gemini CLI 在 2025 年 10 月釋出的新功能，可以看這篇文章: <https://blog.google/technology/developers/gemini-cli-extensions/>

Extension 可以包裝 MCP servers 跟 custom commands，一包帶著走。跟以往需要調整大量設定的情況相比，extension 提供更加便利的工具安裝方式，也更方便分享工具。

我也弄一個 extension 來存放我的 custom commands，repo 在: <https://github.com/nyorc/prompt-book>

## 安全性

工具越是便利，危險程度也是跟著一起增加。 Gemini CLI 預設有一些基本的安全措拖，像是能存取的檔案會限制在啟動 Gemini 時的資料夾。會修改檔案的權限預設都是要使用者確認過才能執行。

但是這些安全措拖不管有多少，重點還是要使用者有安全的使用觀念才有辦法生效。自己做好保險措施最重要，不管是要限制 AI 的權限還是做好備份還原的手段都好。



## Reference

- <https://geminicli.com/>
- <https://geminicli.com/docs/cli/custom-commands/>
