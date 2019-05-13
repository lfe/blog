FROM ruby:2.3.4-alpine

RUN apk update && apk add --no-cache \
    git

COPY pages-gem /src/gh/pages-gem

# one step to exclude .build_deps from docker cache
RUN apk update && apk add --no-cache --virtual .build_deps \
    make build-base && \ 
    apk add --update nodejs python && \
    bundle install --gemfile=/src/gh/pages-gem/Gemfile && \
    apk del .build_deps && \
    rm -rf /var/cache/apk/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /src/site

CMD ["jekyll", "serve", "-H", "0.0.0.0", "-P", "4000"]
