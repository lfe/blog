TITLE ?= New Post
NEW_CMD = rake post title="$(TITLE)"

GEM_PATH = /Users/rv/.gem/ruby/2.0.0/bin
ARCHFLAGS = -Wno-error=unused-command-line-argument-hard-error-in-future
NEW_PATH = $(PATH):$(GEM_PATH)

SRC = ./src
BASE_DIR = $(shell pwd)
BUILD_DIR = $(BASE_DIR)/build
REPO = $(shell git config --get remote.origin.url)

STAGING_HOST = staging-blog.lfe.io
STAGING_PATH = /var/www/lfe/staging-blog

update-gems:
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	sudo gem update --system

install-jekyll: update-gems
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	gem install bundler
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	bundle install

update: install-jekyll
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) && ARCHFLAGS=$(ARCHFLAGS) \
	bundle update

clean:
	rm -rf $(STAGE_PATH)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

build: $(BUILD_DIR)
	cd $(SRC) && \
	bundle exec jekyll build --destination $(BUILD_DIR)

run:
	cd $(SRC) && \
	bundle exec jekyll serve --destination $(BUILD_DIR)

staging: build
	git pull --all && \
	rsync -azP $(BUILD_DIR)/* $(STAGING_HOST):$(STAGING_PATH)
	make clean

publish: build
	@rm -rf $(BUILD_DIR)/.git
	@cd $(BUILD_DIR) && \
	git init && \
	git add * &> /dev/null && \
	git commit -a -m "Generated content." &> /dev/null && \
	git push -f $(REPO) master:gh-pages

new:
	@OUT=$$(cd $(SRC); PATH=$(NEW_PATH) $(NEW_CMD)) ; \
	$(EDITOR) $(SRC)/$$(echo $$OUT | cut -d ' ' -f 4-)
