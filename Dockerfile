FROM github-pages

COPY src /blog
WORKDIR /blog
RUN bundle install

ENTRYPOINT [ "bundle", "exec", "jekyll" ]