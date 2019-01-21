FROM ruby:alpine
MAINTAINER Julius de Bruijn <julius+entropy@nauk.io>

RUN apk update && apk upgrade && apk --update add \
    libstdc++ tzdata bash ca-certificates curl-dev gcc g++ make git \
    mariadb-dev musl-dev libffi-dev zlib-dev libxml2-dev automake \
    && echo 'gem: --no-document' > /etc/gemrc

ENV APP_HOME /diskotappi
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . $APP_HOME

CMD ["bundle", "exec", "ruby", "diskotappi.rb"]
