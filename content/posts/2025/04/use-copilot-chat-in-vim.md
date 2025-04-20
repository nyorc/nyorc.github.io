---
title: "在 Vim 使用 Copilot Chat"
date: 2025-04-20T19:59:15+08:00
tags: [vim, copilot]
---

- 之前的 [試用 Copilot + Vim](/posts/2023/12/try-copilot-with-vim/)，可以在 Vim 上使用 Copilot
- 最近發現 plugin 可以在 vim 上使用 Copilot Chat
- Plugin: https://github.com/DanBradbury/copilot-chat.vim


## 安裝與設定 Copilot Chat

以下為 vim-plug 的安裝方式

- 編輯 .vimrc，加入以下設定
   ```vim
   call plug#begin()
   Plug 'DanBradbury/copilot-chat.vim'
   call plug#end()
   ```
- 執行 :PlugInstall 安裝 plugin



設定 copilot chat

- 執行 `:CopilotChatOpen`
- 畫面會出現一個 github.com 的網址跟驗證碼
- 打開網址，依指示輸入驗證碼，授權給 plugin
- 回到 vim 輸入 enter 即可以使用



## 開始跟 Copilot Chat 對話

### 可以直接跟 Copilot 對話

- 開啟 Chat 對話框後
- 進入 insert mode 輸入 prompt
- 回到 normal mode 按下 enter 會送出 prompt
- 等待 Copilot 的回應



### 或是將選取文字問 Copilot 問題

![](/posts/2025/04/copilot-chat.png)

- 設定好快捷鍵
   ```vim
   " Add visual selection to copilot window
   vmap <space>a <Plug>CopilotChatAddSelection
   ```
- 選取文字後輸入快捷鍵 <space> a，就會將文字放進在 Chat 對話框



## 總結

- vim 上的 copilot 功能又前面一大步了
- 感謝 [DanBradbury](https://github.com/DanBradbury) 開發了這個 plugin
- AI 發展至今，已經是工作上不可或缺的工具了
