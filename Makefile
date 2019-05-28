ENHANCD_ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
SHOVE_URL    := https://github.com/key-amb/shove
SHOVE_DIR    := .ignore/shove
SHOVE_BIN    := $(SHOVE_DIR)/bin/shove
VERSION      := $(_ENHANCD_VERSION)

.DEFAULT_GOAL := help

all:

.PHONY: shove
shove: # Grab shove from GitHub and grant execution
	@test -f $(SHOVE_BIN) || git clone $(SHOVE_URL) $(SHOVE_DIR)
	@test -x $(SHOVE_BIN) || chmod 755 $(SHOVE_BIN)

.PHONY: test
test: shove
	ENHANCD_ROOT=$(PWD) $(SHOVE_BIN) -s bash ./test/*_test.sh
	ENHANCD_ROOT=$(PWD) $(SHOVE_BIN) -s zsh  ./test/*_test.sh

.PHONY: tag
tag:
	git tag -a v$(VERSION) -m v$(VERSION) || true
	git push origin v$(VERSION)

.PHONY: doc
doc:
	a2x \
		--format=manpage \
		--doctype=manpage \
		--destination=doc/man/man1 \
		doc/enhancd.txt
	rm doc/enhancd.xml

.PHONY: build
build: ## Build enhancd image
	docker build -t enhancd -f Dockerfile .

.PHONY: run
run: build ## Run enhancd in docker
	docker run --rm -it enhancd

.PHONY: help
help: ## Show help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
