# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'

require './lib/database'

class RandomMixtape
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!r/).nil?

    url = Database.connection[:urllog].select(:url).
      where{ Sequel.|(Sequel.like(:url, '%soundcloud.com%'),
                      Sequel.like(:url, '%mixcloud.com%')) }.
      order{ rand{} }.first[:url]

    if url =~ /soundcloud.com/
      info = JSON.parse(open_uri(soundcloud_oembed(url)))
    else
      info = JSON.parse(open_uri(mixcloud_oembed(url)))
    end

    m.channel.notice("#{url} (#{info['title']})")
  end

  private

  def soundcloud_oembed(uri)
    "https://www.soundcloud.com/oembed?format=json&url=#{uri}"
  end

  def mixcloud_oembed(uri)
    "http://www.mixcloud.com/oembed?format=json&url=#{uri}"
  end

  def open_uri(uri)
    curl = Curl::Easy.new
    curl.follow_location = true
    curl.useragent = "Ruby/#{RUBY_VERSION}"
    curl.url = uri

    curl.http_get
    curl.body_str
  end
end
