# Stage: Base
FROM alpine

RUN set -ex; \
  apk add --update \
  ca-certificates \
  curl \
  git \
  jq \
  openssh-client \
  perl \
  ruby \
  ruby-json \
  ruby-bundler \
  ruby-bigdecimal \
  ; \
  rm -rf /var/cache/apk/*;

ADD Gemfile Gemfile.lock /opt/resource/
RUN cd /opt/resource && bundle install --without test development
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
ADD scripts/install_git_lfs.sh install_git_lfs.sh
RUN ./install_git_lfs.sh

RUN apk add --update \
    ruby-bundler \
    ruby-io-console \
    ruby-dev \
    openssl-dev \
    alpine-sdk

COPY Gemfile Gemfile.lock /resource/

RUN cd /resource && bundle install

COPY . /resource

RUN cd /resource && rspec
