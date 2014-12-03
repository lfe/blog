GEM_PATH=/Users/oubiwann/.chefdk/gem/ruby/2.1.0/bin
STAGING_HOST=staging-blog.lfe.io
STAGING_PATH=/var/www/lfe/staging-blog
BUILD_DIR=staged

update-gems:
	PATH=$(PATH):$(GEM_PATH) \
	sudo gem update --system

install-jekyll:
	PATH=$(PATH):$(GEM_PATH) \
	sudo gem install bundler
	PATH=$(PATH):$(GEM_PATH) \
	bundle install

update: update-gems install-jekyll
	PATH=$(PATH):$(GEM_PATH) \
	bundle update

clean:
	rm -rf ./$(BUILD_DIR)

build: clean
	bundle exec jekyll build --destination ./$(BUILD_DIR)

run: clean
	bundle exec jekyll serve --destination ./$(BUILD_DIR)

staging: build
	git pull --all && \
	rsync -azP ./$(BUILD_DIR)/* $(STAGING_HOST):$(STAGING_PATH)

publish: clean
	git commit -a && git push --all

