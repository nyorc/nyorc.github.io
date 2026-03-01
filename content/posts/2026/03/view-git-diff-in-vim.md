---
title: "在 Vim 看看目前有哪些 Git 異動"
date: 2026-03-01T23:59:50+08:00
tags: [vim, git]
---

想要在 Vim 直接看到 git 異動，有兩個 plugin 可以搞定
- [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
- [fugitive.vim](https://github.com/tpope/vim-fugitive)



## vim-gitgutter

安裝後要有兩個設定值要注意

- updatetime 更新時間設定成 100ms 效果會比較好，預設是 4000ms
   - 查看 `:set updatetime`
   - 設定 `:set updatetime=100`

- signcolumn 不要是 off 就好，預設是 auto
   - 查看 `:set signcolumn`



安裝好之後 vim 右側的 sign column 看到 git diff 資訊，用符號表示「新增」、 「修改」、「刪除」，預設符號:
- 新增: `+`
- 修改: `~`
- 刪除: `-`



可以在異動區塊之間快速移動:
- `[c` : 跳往前一個異動的區塊
- `]c` : 跳往下一個異動的區塊

## fugitive.vim

這個 plugin 可以在 vim 下執行所有的 git 操作，基本使用方式輸入指令 `:Git <args>` 或 `:G <args>` 可以直接執行 git 指令，例如 `:G branch` 等同於 `git branch` 。

直接執行 `:Git` 或 `:G` 不帶參數，會開啟 summary window 顯示 repo 的 `git status` 資料，並且有相當完整的快捷鍵可以直接執行 git 操作

在 summary window 裡操作範例:

- 切換開發分支
   - `co<space>`: 直接跳出指令 `:Git checkout ` 
   - 再補上後面的參數 `:Git checkout -b feature-branch` 
- 回到檔案中，修修改改你要改動的內容
   - `gq`: 離開 summary window
- 查看修改內容
   - `dp`: 瀏覽遊標位置的檔案 diff
   - `dv`: 水平分割視窗開啟遊標位置的檔案 diff，等同指令 `:Gvdiffsplit`
   - `dq`: 關閉所有 diff window
- 加入暫存區 (Staging Area)
   - `s`: 將檔案或異動區塊 stage
   - `u`: 將檔案或異動區塊 unstage
   - `-`: 切換 stage 狀態
   - `U`: Unstage 全部異動
   - `=`: 開關檔案的 inline diff
   - 可以用 visual mode 選多個檔案或是部分的異動區塊做批次操作
- 提交 (Commit)
   - `cc`: 建立 commit
   - `ca`: 修改 commit message (就是 `--amend`)
   - `c<space>`: 跳出指令 `:Git commit ` 

使用 `:Git blame` 開啟水平分割視窗看 blame 資料，有提供操作功能
- `-`: 在遊標位置的 commit 再 blame 一次
- `gq`: 關閉 blame 介面



## 小結

vim-gitgutter 加上 fugitive.vim 基本上解決了基本的使用場景，還有很多功能我目前也還熟悉中，有需要時再用 `:help` 翻文件看看。
