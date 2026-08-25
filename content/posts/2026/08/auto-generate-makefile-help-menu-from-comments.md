---
title: "從註解自動產生 Makefile Help Menu"
date: 2026-08-25T22:49:15+08:00
tags: [makefile]
---

以前看過利用 script 從 Makefile 的註解產生 help menu，可以讓說明跟 target 放一起，不用多維護一份用 echo 寫的說明書。最近有用到，整理一下大概會有的寫法。

## 怎麼運作的?

script 的概念很簡單，以 `##@` 標記開頭的會當做 target 群組文字，以 `##` 字串開頭接在 target 後面來寫說明，再使用可以處理文字的指令把標記跟說明文字找出來。

實際上可以有 N 種寫法，從純 shell script 到使用 python, perl 等等的 script language 都是可以的，不過還是讓 script 對環境的要求簡單一點會比較實用。

以下整理了幾種常見指令的版本，並在 macOS 上測過是可以運作的。

## grep + sed + column

ps. 這個版本沒有群組

Makefile

```make
help: ## Show this help message
	@echo 'Usage:'
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
		| sed -E 's/:[^#]*## */|/' \
		| column -t -s '|'

build: ## Compile the code
	@echo 'start building'

test: ## Run test
	@echo 'start testing'
```

output

```bash
$ make help
Usage:
help   Show this help message
build  Compile the code
test   Run test
```

語法說明

- `$(MAKEFILE_LIST)` 是 make 的內建變數，內容是所有讀到的 makefile 路徑
- grep 找 `##` ，sed 把冒號到 `##` 的字元換成 `|` ，column 以 `|` 切欄位排版

## awk

Makefile

```make
##@ General

.PHONY: help
help: ## Show this help message using awk
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n"} \
		/^##@/ { sub(/^##@ */, ""); printf "\n\033[0;33m%s\033[0m\n", $$0; next } \
		/^[a-zA-Z_-]+:.*##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

##@ Development

build: ## Compile the code
	@echo 'start building'

test: ## Run test
	@echo 'start testing'
```

output

```bash
$ make help
Usage:

General
  help             Show this help message using awk

Development
  build            Compile the code
  test             Run test
```

語法說明

- `FS` 以正規表達式當欄位分隔符號

## shell

Makefile

```make
##@ General

.PHONY: help
help: ## Show this help message using shell
	@echo 'Usage:'
	@cat $(MAKEFILE_LIST) | while IFS= read -r line; do \
		case $$line in \
			'##@ '*) \
				printf '\n\033[0;33m%s\033[0m\n' "$${line#'##@ '}";; \
			[a-zA-Z_-]*:*'##'*) \
				printf '  \033[36m%-20s\033[0m%s\n' "$${line%%:*}" "$${line#*'## '}";; \
		esac; \
	done

##@ Development

build: ## Compile the code
	@echo 'start building'

test: ## Run test
	@echo 'start testing'
```

output

```bash
$ make help
Usage:

General
  help                Show this help message using shell

Development
  build               Compile the code
  test                Run test
```

語法說明

- `case` 分別找出有 `##@` 跟 `##` 符號的那幾行

## Reference

- <https://gist.github.com/prwhite/8168133>
- <https://github.com/cavo789/blog/blob/main/makefile>
