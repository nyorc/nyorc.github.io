---
title: "讓 Vim 自動載入硬碟中的檔案異動"
date: 2026-01-15T20:57:25+08:00
tags: [vim, tmux]
---

Vim 開啟檔案時會將檔案載入 buffer 中，預設不會去同步硬碟中的檔案異動。

在一些使用情境下例如 git 切換分支時，或是 AI Agent 幫你修改過檔案時，buffer 沒有一起更新，會讓工作變得有點不順手。

下面整理一些解決辦法。

## 可以手動觸發更新 

有幾個方法可以手動觸發更新 buffer
- 執行 `:e`  直接重新載入檔案
- 執行 `:checktime` 會檢查硬碟中的檔案有無異動，在發現異動時通知你
   ```vim
   :checktime
   W11: Warning: File "README.md" has changed since editing started
   See ":help W11" for more info.
   [O]K, (L)oad File, Load File (a)nd Options:
   ```



## 做到自動化同步

下面完整版可以直接使用，或是看後面的說明做個人化調整

### 完整版

```vim
" enable autoread files changed on disk
set autoread

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
```

### 啟用 autoread

`set autoread`

啟用後發現檔案有異動而且 buffer 不是編輯中的情況下，會自動載入檔案。

這個設定不會自動去檢查檔案，需要搭配下面的 `autocmd` 才會是自動觸發。



### 設定自動化指令觸發 autoread

```vim
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
```

會觸發的事件清單
- FocusGained: focus vim 視窗時
- BufEnter: 開啟/切換 buffer 時
- CursorHold/CursorHoldI: 游標靜止不動超過 updatetime 時 (updatetime 預設是 4 秒)

並且必免在這些模式下觸發，以免影響操作:
- Command
- Replace
- Shell
- Terminal



### 設定檔案更新時通知

```vim
autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
```

當檔案異動事件(FileChangedShellPost) 觸發時，會輸出文字提示

## Tmux 使用者需要額外設定才會觸發 FocusGained
1. vim 裝 plugin: <https://github.com/tmux-plugins/vim-tmux-focus-events>
2. `.tmux.conf` 加上設定
  ```conf
  set -g focus-events on
  ```

## Reference

- [vim - refresh changed content of file opened in vi(m) - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044)


