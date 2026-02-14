---
title: "在 Vim 快速複製目前的檔案路徑"
date: 2026-02-14T15:47:24+08:00
tags: [vim]
---

最近越來越常需要自己打字輸入正在編輯中的檔案路徑，但是打字很累，於是又到了調校 vim 的時間。
基本上就是找到拿到檔案路徑的辦法，然後設定成快捷鍵，就可以開心工作了。

## 複製檔案相對路徑

vim 要拿到檔案路徑，有 `expand('%')` 這個方法可以辦到。而作業系統的剪貼簿相通變數 `@+` ，只要賦值給 `@+` 就是等同於複製了。

使用 vimscript 便可以將路徑複製到剪貼簿:
```vim
:let @+=expand('%')
```

設定成快捷鍵:
```vim
nnoremap <leader>yf :let @+=expand('%')<CR>
```

## 無法複製相對路徑

設定完快捷鍵後，我以為就此完工了，但是現在這組快捷鍵有時會有問題，複製的路徑不是「相對路徑」而是「絕對路徑」。

因為 netrw 預設是用「絕對路徑」開啟檔案的，所以複製會變成「絕對路徑」。
所以這邊要修正 `expand('%')` 的寫法，使用 `'%:.'` 拿到相對路徑。

現在的快捷鍵設定:
```vim
nnoremap <leader>yf :let @+=expand('%:.')<CR>
```



## 加入配合 AI Agent 的常用複製方法

再根據近期使用 AI Agent 的情境來增加複製快捷鍵:
- 複製目前的檔案路徑跟所在行數
- 複製目前的檔案路徑跟選取的行數範圍

要取得行數資訊，可以使用 `line()` 這個函式，組合成 `<file path>:<line number>` 的格式

複製檔案路徑跟所在行數快捷鍵:
```vim
nnoremap <Leader>yl :let @+=expand('%:.') . ':' . line('.')<CR>
```

複製檔案路徑跟選取範圍快捷鍵:
```vim
vnoremap <Leader>yf :<C-u>let @+=expand('%:.') . ':' . line("'<") . '-' . line("'>")<CR>
```



## 最終版本

最後，加上一點文字提示，方便知道操作成功。以下是這次的完整版設定:
```vim
" use '%:.' to get relative path from current working directory
" copy relative file path to clipboard
nnoremap <Leader>yf :let @+=expand('%:.')<CR>:echo 'Copied: ' . expand('%:.')<CR>
" copy file path:line to clipboard
nnoremap <Leader>yl :let @+=expand('%:.') . ':' . line('.')<CR>:echo 'Copied: ' . expand('%:.') . ':' . line('.')<CR>
" copy file path:startline-endline to clipboard
vnoremap <Leader>yf :<C-u>let @+=expand('%:.') . ':' . line("'<") . '-' . line("'>")<CR>:echo 'Copied range'<CR>

```
