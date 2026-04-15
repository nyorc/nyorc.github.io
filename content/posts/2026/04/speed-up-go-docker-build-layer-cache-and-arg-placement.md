---
title: "Go 專案的 Docker Build 加速：分層快取跟 ARG 位置"
date: 2026-04-15T22:54:21+08:00
tags: [go, docker]
---

在 Dockerfile 裡 build golang 程式總是要花個幾分鐘，雖然不多，但是反覆的測試跟修改程式下，往往也花掉了不少時間。

目前使用的 Dockerfile 大概如下，在舊筆電 build 一次大概要 2 分鐘多

```dockerfile
FROM golang:1.24-alpine AS builder

ARG VERSION=v0.0.0
ARG COMMIT=unknown

WORKDIR /src
ADD . /src

RUN CGO_ENABLED=0 go build \
        -ldflags "-X github.com/nyorc/go-ver.Version=${VERSION} \
            -X github.com/nyorc/go-ver.BuildTime=$(date +%Y/%m/%dT%H:%M:%S) \
            -X github.com/nyorc/go-ver.Commit=${COMMIT}" \
        -o app

FROM alpine:latest
COPY --from=builder /src/app /bin/app
ENTRYPOINT [ "/bin/app" ]

```



筆電環境
- docker version: 28.3.3
- os: Debian 12

這邊稍為理解 docker 運作方式，Dockerfile 裡只要是操作到檔案系統的指令(FROM、COPY、RUN、CMD)就會建一層 image layer。
反覆的執行 docker build 時，只有內容有改動時才會重新打包 image，沒有變動的 layer 就拿之前存下來的快取直接使用。

## 提前下載 package，再 build 執行檔

go build 會做兩件事，先下載依賴的 package，再編譯執行檔。程式碼是每次都會變動的，但是 package 就不是了，因此可以將這兩件事分開來，沒有變動 package 時 docker 可以快取下載 package。

Dockerfile 的調整成先處理 go mod，如下

```dockerfile
# 原版 (依賴與原始碼綁定)
ADD . /src
RUN CGO_ENABLED=0 go build ...

# 改良 (依賴獨立一層)
COPY go.mod go.sum ./       # 只複製依賴定義檔
RUN go mod download         # 獨立下載 package
COPY . .
RUN CGO_ENABLED=0 go build
```

測試改動程式碼再 docker build，下載 package 有中 cache，省下大約 11 秒。

```dockerfile
=> CACHED [builder 4/6] RUN go mod download 0.0s
```

## 因 ARG 位置影響到 docker build 快取

多次測試後發現一個問題，改變 commit 之後，下載 package 反而重跑一次了。

```dockerfile
=> [builder 4/6] RUN go mod download 12.3s
```

Dockerfile 有設定 `ARG COMMIT` 跟 `ARG VERSION` 作為 `go build` 的參數，ARG 放在 `go mod download` 之前，ARG 的內容改變會讓 cache 失效，要重新下載。

解決方案是把 ARG 移到實際引用的地方，這樣即使 ARG 內容改變，也不影響前面的 image layer。

```dockerfile
COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG VERSION=v0.0.0              # 移到這裡
ARG COMMIT=unknown
RUN CGO_ENABLED=0 go build ...
```

再次測試只要沒有改動 `go.mod` 就算有新的 commit 也保持使用快取

```dockerfile
=> CACHED [builder 3/6] COPY go.mod go.sum ./ 0.0s
=> CACHED [builder 4/6] RUN go mod download 0.0s
```

## 總結

成功讓下載 package 快取，但是小型專案的 package 不多，只省下 10 多秒，最秏費時間是在老舊筆電上編譯要花超過 2 分鐘。

最終版 Dockerfile
```dockerfile
FROM golang:1.24-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG VERSION=v0.0.0
ARG COMMIT=unknown
RUN CGO_ENABLED=0 go build \
        -ldflags "-X github.com/nyorc/go-ver.Version=${VERSION} \
            -X github.com/nyorc/go-ver.BuildTime=$(date +%Y/%m/%dT%H:%M:%S) \
            -X github.com/nyorc/go-ver.Commit=${COMMIT}" \
        -o app

FROM alpine:latest
COPY --from=builder /src/app /bin/app
ENTRYPOINT [ "/bin/app" ]
```
