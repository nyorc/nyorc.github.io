---
title: "最輕量安裝的 Debian 加 Gnome "
date: 2025-07-20T00:15:28+08:00
tags: ["debian", "gnome"]
---


原本手上有台筆電是安裝 ubuntu 的，但是最近一些問題不想繼續使用

- 預設的應用程式，強制改用 snap 安裝
- 會看到 ubuntu pro 的廣告
- OS 版本更新雖然快，但是不穩定
- 效能有點差

所以我打算回到 Debian，自己掌握自己的筆電，選擇最小安裝，只安裝有需要的軟體，以最小化需要的硬碟空間跟記憶體

## 製作安裝 Debian 的 USB 隨身碟

首先要來製作安裝用的 USB 隨身碟。對，我在 ubuntu 上準備 debian 的安裝隨身碟

### 下載 OS Image

- image 選擇目前的 stable 版 (12 bookworm) 的 netinst 版本

   - network install 版本在安裝時需要網路
   - image 大小是 670MB
   - 下載連結在 <https://www.debian.org/download>
   - [debian-12.11.0-amd64-netinst.iso](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso)

### 複製檔案到 usb

- 使用 `lsblk` 或是 `sudo fdisk -l` 找到 usb 掛載的位置，我的筆電掛載在 `/dev/sdb`
- 執行 cp 指令
   ```bash
   cp debian-12.11.0-amd64-netinst.iso /dev/sdb
   ```

## 開始安裝 Debian

### 安裝最基礎的 Debian 系統

拿前進製作好的 USB 進入 debian 的安裝程式，到 software selection 步驟，只要勾選 standard system utilities。

![](/posts/2025/07/debian-software-selection.png)


### 安裝桌面環境

桌面環境有 Gnome, Xfce, KDE Plasma, LXQT 等很多選擇，我選用習慣的 Gnome

```bash
sudo apt install gnome-shell
```

### 移除 ifupdown

因為 Gnome 的 `NetworkManager` 跟 `ifupdown` 都是管理網卡的軟體，要在 Gnome 上可以設定網路，需要移除 `ifupdown` 讓  `NetworkManager` 接管網卡

- 移除 `ifupdown`
   ```bash
   sudo apt purge ifupdown
   ```
- 修改 `/etc/NetworkManager/NetworkManager.conf` ，`managed=false` 改成 `managed=true`
- 重啟電腦讓設定生效

## 安裝必要的軟體

基本的作業系統跟桌面環境安裝完成後，再來就是要逐步打造需要的工作環境了

```bash
sudo apt install \
  gnome-tweaks \
  firefox-esr \
  alacritty \
  git 
```



## Reference
- <https://github.com/coonrad/Debian-Gnome-Minimal-Install>
- <https://ostechnix.com/debian-minimal-gnome-install/>
- <https://wiki.debian.org/NetworkConfiguration>
