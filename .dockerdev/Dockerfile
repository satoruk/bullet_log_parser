ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim-buster

ARG BUNDLER_VERSION
ARG NODE_MAJOR
ARG PROJECT_DIR
ARG REVIEWDOG_VERSION
ARG YARN_VERSION

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends  -qq \
  build-essential \
  gnupg2 \
  curl \
  less \
  git \
  && apt-get clean -qq \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install reviewdog
RUN curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin v$REVIEWDOG_VERSION

# Install dependencies
COPY .dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  nodejs \
  yarn=$YARN_VERSION-1 \
  $(cat /tmp/Aptfile | xargs) && \
  apt-get clean -qq && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLER_VERSION=$BUNDLER_VERSION \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Upgrade RubyGems and install required Bundler version
# See https://github.com/evilmartians/terraforming-rails/pull/24 for discussion
RUN gem update --system && \
  rm /usr/local/lib/ruby/gems/*/specifications/default/bundler-*.gemspec && \
  gem uninstall bundler && \
  gem install bundler:$BUNDLER_VERSION && \
  mkdir -p ${PROJECT_DIR}

WORKDIR ${PROJECT_DIR}
