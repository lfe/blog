TITLE ?= New Post
SRC = ./src
BASE_DIR = $(shell pwd)
BUILD_DIR = $(BASE_DIR)/build
REPO = $(shell git config --get remote.origin.url)
GITHUB_PAGES = docker/gh-pages/pages-gem

.PHONY: build

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

$(GITHUB_PAGES):
	mkdir -p `basename $(GITHUB_PAGES)`
	git clone git@github.com:github/pages-gem.git $(GITHUB_PAGES)
	cd $(GITHUB_PAGES) && \
	git checkout v24

$(GITHUB_PAGES)/.build: $(GITHUB_PAGES)
	docker build docker/gh-pages -t github-pages && \
	touch $(GITHUB_PAGES)/.build

clean-github-pages:
	rm -rf $(GITHUB_PAGES)

build: $(GITHUB_PAGES)/.build
	# @mkdir -p $(BUILD_DIR)
	# cd $(SRC) && \
	# bundle exec jekyll build --destination $(BUILD_DIR)
	docker build . -t lfe/blog
	docker run --volume="`pwd`/build:/blog/build" lfe/blog build --verbose --trace --destination /blog/build

run:
	docker run -p 4000:4000 --volume="`pwd`/build:/blog/build" lfe/blog serve --destination $(BUILD_DIR)

new:
	@docker run --entrypoint=rake --volume="`pwd`/src/_posts:/blog/_posts" lfe/blog post title="$(TITLE)"

post:
	@OUT=$$($(MAKE) new | cut -d ' ' -f 4-) ; \
	$(EDITOR) $(SRC)/$$OUT
