FROM ruby:2.6.4-slim
ENV LANG C.UTF-8

RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev postgresql-client imagemagick libmagickwand-dev curl nodejs yarn \
  && rm -rf /var/lib/apt/lists/* \
  && gem update

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN gem install bundler

WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/

COPY . /app
RUN bundle install -j4
RUN yarn install
EXPOSE 3000

CMD bundle exec rails s puma -b 0.0.0.0 -p 3000 -e ${RAILS_ENV}
