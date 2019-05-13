TITLE ?= New Post
BASE_DIR = $(shell pwd)
SRC = $(BASE_DIR)/src
BUILD_DIR = $(BASE_DIR)/build
POSTS_DIR = $(SRC)/_posts
PUBLISH_DIR = $(BASE_DIR)/generated
GUEST_BUILD_DIR = /blog/build
GUEST_POSTS_DIR = /blog/_posts
REPO = $(shell git config --get remote.origin.url)
GITHUB_PAGES = docker/gh-pages/pages-gem

.PHONY: build

default: build

$(GITHUB_PAGES):
	@mkdir -p `basename $(GITHUB_PAGES)`
	@git clone git@github.com:github/pages-gem.git $(GITHUB_PAGES)
	@cd $(GITHUB_PAGES) && \
	git checkout v24

$(GITHUB_PAGES)/.build: $(GITHUB_PAGES)
	@cd docker/gh-pages && \
	docker build . -t github-pages && \
	touch $(GITHUB_PAGES)/.build

build: clean-build $(GITHUB_PAGES)/.build
	@docker build . -t lfe/blog
	@docker run --volume="$(BUILD_DIR):/$(GUEST_BUILD_DIR)" lfe/blog build --verbose --trace --destination $(GUEST_BUILD_DIR)
	@cp -r $(BUILD_DIR)/* $(PUBLISH_DIR)/

build-and-publish: build publish

run: build
	@docker run -p 4000:4000 --volume="$(BUILD_DIR):$(GUEST_BUILD_DIR)" lfe/blog serve --destination $(GUEST_BUILD_DIR)

new:
	@docker run --entrypoint=rake --volume="$(POSTS_DIR):$(GUEST_POSTS_DIR)" lfe/blog post title="$(TITLE)"

post:
	@OUT=$$($(MAKE) new | cut -d ' ' -f 4-) ; \
	$(EDITOR) $(SRC)/$$OUT

publish:
	@cd $(PUBLISH_DIR) && \
	git commit -am "Regenerated LFE blog content." > /dev/null && \
	git push origin gh-pages
	@git add $(PUBLISH_DIR)	&& \
	git commit -m "Updated submodule to recently published blog content." && \
	git push origin master

clean-github-pages:
	@rm -rf $(GITHUB_PAGES)

clean-build:
	@rm -rf $(BUILD_DIR)

clean-all: clean-build clean-github-pages
