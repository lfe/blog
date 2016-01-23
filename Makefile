TITLE ?= New Post
NEW_CMD = rake post title="$(TITLE)"

ARCHFLAGS = -Wno-error=unused-command-line-argument-hard-error-in-future

SRC = ./src
BASE_DIR = $(shell pwd)
BUILD_DIR = $(BASE_DIR)/build
REPO = $(shell git config --get remote.origin.url)

STAGING_HOST = staging-blog.lfe.io
STAGING_PATH = /var/www/lfe/staging-blog

OS := $(shell uname -s)
ifeq ($(OS),Linux)
	HOST = $(HOSTNAME)
	GEM = sudo gem
	NEW_PATH = $(PATH)
endif
ifeq ($(OS),Darwin)
	HOST = $(shell scutil --get ComputerName)
	GEM = gem
	GEM_PATH = /Users/rv/.gem/ruby/2.0.0/bin
	NEW_PATH = $(PATH):$(GEM_PATH)
endif

ubuntu-deps:
	sudo apt-get install -y nodejs nodejs-dev

new:
	@OUT=$$(cd $(SRC); PATH=$(NEW_PATH) $(NEW_CMD)) ; \
	$(EDITOR) $(SRC)/$$(echo $$OUT | cut -d ' ' -f 4-)

post:
	@make new

update-gems:
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	$(GEM) update --system

install-jekyll: update-gems
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	$(GEM) install bundler
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	bundle install

update: install-jekyll
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	bundle update

clean:
	rm -rf $(BUILD_DIR)

build:
	@mkdir -p $(BUILD_DIR)
	cd $(SRC) && \
	bundle exec jekyll build --destination $(BUILD_DIR)

run:
	cd $(SRC) && \
	bundle exec jekyll serve --destination $(BUILD_DIR)

staging: clean build
	git pull --all && \
	rsync -azP $(BUILD_DIR)/* $(STAGING_HOST):$(STAGING_PATH)
	make clean

publish: clean build
	-@git commit -a; git push origin master
	@rm -rf $(BUILD_DIR)/.git
	@cd $(BUILD_DIR) && \
	git init && \
	git add * > /dev/null && \
	git commit -a -m "Generated content." > /dev/null && \
	git push -f $(REPO) master:gh-pages

force-publish: clean build
	-@git commit -a --amend; git push --force origin master
	@rm -rf $(BUILD_DIR)/.git
	@cd $(BUILD_DIR) && \
	git init && \
	git add * > /dev/null && \
	git commit -a -m "Generated content." > /dev/null && \
	git push -f $(REPO) master:gh-pages

