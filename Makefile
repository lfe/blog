SRC=./src
GEM_PATH=/Users/oubiwann/.chefdk/gem/ruby/2.1.0/bin
STAGING_HOST=staging-blog.lfe.io
STAGING_PATH=/var/www/lfe/staging-blog
BUILD_DIR=$(shell pwd)
STAGE_DIR=$(BUILD_DIR)/staged

update-gems:
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) \
	sudo gem update --system

install-jekyll: update-gems
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) \
	sudo gem install bundler
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) \
	bundle install

update: install-jekyll
	cd $(SRC) && PATH=$(PATH):$(GEM_PATH) \
	bundle update

clean:
	rm -rf $(STAGE_DIR)

$(STAGE_DIR):
	cd $(SRC) && \
	bundle exec jekyll build --destination $(STAGE_DIR)

run-stage: clean
	cd $(SRC) && \
	bundle exec jekyll serve --destination $(STAGE_DIR)

build: clean
	cd $(SRC) && \
	bundle exec jekyll build --destination $(BUILD_DIR)

run: clean
	cd $(SRC) && \
	bundle exec jekyll serve --destination $(BUILD_DIR)

staging: $(STAGE_DIR)
	git pull --all && \
	rsync -azP ./$(BUILD_DIR)/* $(STAGING_HOST):$(STAGING_PATH)
	make clean

publish: clean
	git commit -a && git push --all

