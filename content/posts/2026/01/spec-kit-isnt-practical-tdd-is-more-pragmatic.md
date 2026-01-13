---
title: "Spec-kit 並沒有很實用，TDD 比較實在"
date: 2026-01-14T00:23:50+08:00
tags: [spec-kit, sdd, tdd]
---

最近 github 推的 spec-kit 很熱門，感覺只要是軟體工程師一定要用看看，所以我也小試了一下。

## Spec-kit 是什麼

spec-kit 把 SDD (Spec-Driven Development) 跟 AI Agent 結合，開發者可以請 AI Agent 幫忙從寫 spec 文件開始逐步做到實作程式碼。

SDD 的核心概念是先寫好 spec，再跟據 spec 實作程式碼。

spec-kit 把 SDD 定成四個階段: specify → plan → tasks → implement
- `specify`: 提供需求描述，讓 AI 寫 spec 文件。
- `plan`: 讓 AI 跟據 spec 文件，規畫技術選型、程式架構、設計 API、設計資料結構等。
- `tasks`: 讓 AI 跟據 plan 結果，拆分執行任務。
- `implement`: 讓 AI 開始實作程式。

當我們有提供足夠的 context，AI 可以順利的從寫文件到完成程式碼。但如果沒有跟 AI 交代清楚，AI 就會自由發揮，需要再下 prompt 請 AI 修改。

## Spec-kit 試用感想

spec-kit 新手的我，在試用的過程有點挫折：
- 因為不可能一次就把需求的 context 寫得很完美，通常都需要反覆補充 context 並修改 spec，這反而讓我花更多時間跟 token 叫 AI 反覆的修改文件。
- spec-kit 產生了大量的文件，大幅增加 review 文件的成本。
- 生成的文件只有 spec 有一點保留的價值，剩下的文件都是為了給 AI 看而產生的中間產物，這些資料最後都會被寫到程式碼、doc string、README 等地方。
- spec-kit 使用過程中間生成的文件跟程式碼，就是兩份重複描述程式要怎麼運作的文件，如果要保留下來就需要同步更新，會有漏改的問題。

這些挫折讓我在思考使用 spec-kit 有什麼幫助，我使用 TDD 跟 AI Agent 一起開發程式並不會碰到這些問題。

## TDD(Test-Driven Development) 是什麼

TDD 的核心概念是先了解程式是如何被使用，寫成可以執行的 Spec aka 測試程式，再寫出可以滿足測試的程式碼。
- 程式是「如何被使用」就是「使用案例」，可以是很單純的輸入(input)跟輸出(output)，或是比較有結構的描述 ex.什麼情況下，當做什麼事，會得到什麼結果(given, when, then)



TDD 的開發過程是通常被濃縮三個步驟反覆循環: 

紅燈(Red) → 綠燈(Green) → 重構(Refactor) → 紅燈(Red)...
- `紅燈(Red)`: 將程式會如何被使用的期望，寫一個會失敗的測試程式。
- `綠燈(Green)`: 寫出足以通過測試的程式。
- `重構(Refactor)`: 重構程式以確保其可維護性。

## TDD 搭配上 AI Agent

我以 TDD 搭配 AI Agent 的開發過程會是這樣:
- 紅燈(Red): 抓一個使用案例，讓 AI 寫一個會失敗的測試程式並執行測試。
- 綠燈(Green): 讓 AI 寫出足以通過測試的程式並執行測試。
- 重構(Refactor): 讓 AI 跟據我提出的要求，重構程式。

## 為什麼 TDD + AI Agent 不會有 Spec-kit 的挫折?

按照 TDD 來開發程式
- 更能夠保證 AI 每次只實作一個小功能，不會生成大量程式碼，這樣我們對程式碼的變動有更高的掌握度，review 程式也更加輕鬆。
- 不會增加多餘的文件，所有的程式跟文件都是必要的。
- 保證會有一份「測試程式」可以驗證程式是否正確，可以放心的 refactor。



## 小結

目前我無法在 spec-kit 身上找到可以幫助我的部份。倒也不是說 spec-kit 不好，也有很多人用得很開心，至少以我小試一下的做法跟實驗環境不適合使用它，只會讓我變成一直在修 spec 的工程師。

如果你在考慮 spec-kit，可以評估看看 spec-kit 對你是否有幫助，或者只會徒增一堆文件?

使用 TDD 一直是我的主要開發手段，搭配 AI Agent 一樣是首選，這次的實驗也讓我更確信這一點。



## Reference

- [Spec-driven development with AI: Get started with a new open source toolkit - The GitHub Blog](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)

- <https://github.com/github/spec-kit>

- [Spec-Driven Development(SDD) 的美好願景與殘酷現實 – ihower { blogging }](https://ihower.tw/blog/13480-sdd-spec-driven-development)

- [Kent Beck 的 Claude Code 規則翻譯：TDD 與 Tidy First 的實踐指南 | Cash Wu Geek](https://blog.cashwu.com/blog/2025/kent-beck-claude-code-rules-translation)
