.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n"} \
		/^##@/ { sub(/^##@ */, ""); printf "\n\033[0;33m%s\033[0m\n", $$0; next } \
		/^[a-zA-Z_-]+:.*##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: server
server: ## start hugo dev server with draft post
	hugo server -D --logLevel info

.PHONY: build
build: ## render static file
	hugo --logLevel info

.PHONY: new-post
new-post: ## create new post
ifdef POST
	hugo new --logLevel info posts/$$(date +%Y/%m)/$$(echo $(POST) | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]').md
endif
ifndef POST
	@echo empty post title
endif

