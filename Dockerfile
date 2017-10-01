FROM ruby:alpine
MAINTAINER Julius de Bruijn <julius.debruijn@360dialog.com>

RUN apk update && apk upgrade && apk --update add \
    libstdc++ tzdata bash ca-certificates curl-dev gcc g++ make \
    mariadb-dev musl-dev libffi-dev zlib-dev libxml2-dev automake \
    && echo 'gem: --no-document' > /etc/gemrc

ADD . /diskotappi
WORKDIR /diskotappi
RUN mkdir /diskotappi/.bundles

ENV BUNDLE_PATH "/diskotappi/.bundles"
ENV BUNDLE_DISABLE_SHARED_GEMS "1"
RUN bundle install

CMD ["ruby", "diskotappi.rb"]
