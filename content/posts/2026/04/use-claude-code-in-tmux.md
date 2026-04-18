---
title: "在 tmux 裡使用 claude code"
date: 2026-04-18T19:59:59+08:00
tags: [tmux, claude code]
---

平常使用 terminal 習慣一打開就是先開啟 tmux，再開始處理要做的事情。現在 Claude Code 入列常用的工具之一的情況下，跟 tmux 一起使用是很舒適的體驗。

使用 Claude Code 時，常常會變成多工的狀態。Claude Code 還在執行中，就先翻翻資料，或是開啟多個 Claude Code 分別處理不同的任務。

Claude Code 的多工場景變成常態的情況下，有各式各樣跟 Claude Code 結合的新工具出現，但看過去發現很多功能像是分頁、分割畫面等，其實 tmux 就有了。已經有使用 tmux 的我並不需要花時間重新熟悉新工具。

以下介紹我目前是怎麼使用 tmux 搭配 Claude Code 的。

## 分割畫面可以同時看到更多的資訊

使用 tmux 把 terminal 切成左右兩個畫面，目前習慣是左邊開 Claude Code 右邊開 vim，有需要翻 git 記錄時右邊再上下切半。可以把 vim 的文字直接複製到 Claude Code 裡，或是 Claude Code 還在處理資料時，可以在另一邊做其他的事情。

![左邊 Claude Code、右邊 vim 的 tmux 分割畫面](/posts/2026/04/use-claudecode-in-tmux.png)

順帶一提 Claude code 也能操作 tmux，如果在右邊的畫面有 error message，Claude Code 是有辦法直接讀取，只要 prompt 有提示它要去哪邊看 error message 就行。

## 保留 session 在背景工作

就像是瀏覽器可以開分頁一樣，tmux 可以開多個 window。畫面顯示其中一個 window，其他的就在背景保持運作。丟比較複雜的 prompt 給 Claude Code 處理時，可以放到背景去處理，晚點再回來看結果。

另外就算把 terminal 直接關掉，也不會中斷 tmux 裡面的 Claude Code，tmux 的 session 還是保留在背景中，只要重新打開 tmux attach 原本的 session 就可以繼續使用。同樣的在 ssh 連線的環境下，網路斷線時 tmux session 還是會在的。

## 實用的 Tmux 設定

這邊分享一下目前使用中的 tmux 設定，官方建議的設定在: <https://code.claude.com/docs/zh-TW/terminal-config>，有一點點 tmux 相關的內容。

我覺得以下的設定可以讓使用 Claude Code 更加便利
- history 加大方便看 Claude Code 的對話串
- 啟用滑鼠功能

```bash
# set history up to 100000
set -g history-limit 100000

# enable mouse
set -g mouse on
```

以下是我的一些快捷鍵設定
- 水平、垂直分割畫面，切割上、下、左、右側邊的 sidebar
- 在分割的畫面之間以 ctrl + h,j,k,l 移動遊標 (支援 vim)

```bash
# split window with | and -
bind-key \\ split-window -h -c '#{pane_current_path}'
bind-key - split-window -v -c '#{pane_current_path}'
unbind '"'
unbind %

# split small sidebar
bind-key h split-window -h -b -l 20% -c '#{pane_current_path}'
bind-key l split-window -h -l 20% -c '#{pane_current_path}'
bind-key j split-window -v -l 20% -c '#{pane_current_path}'
bind-key k split-window -v -b -l 20% -c '#{pane_current_path}'

# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind-key -n C-\\ if-shell "$is_vim" "send-keys C-\\\\" "select-pane -l"
```

搭配 tmux 原有的快捷鍵，基本上很夠用
- `prefix + w` : window 清單
- `prefix + s` : session 清單
- `prefix + d` : detach tmux

## 下一步

看過其他工具或是別人的經驗分享，感覺是大同小異，目前使用下來感覺算是很舒服的。

當然還是有一些情境可以再做一點調整，目前覺得可以再補充的功能是: 開很多 Claude Code session 時，沒有辦法可以一次看到全部的 Claude Code session 狀態。當做下次的筆記主題吧。

