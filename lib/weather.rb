# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'

class Weather
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!w [a-zA-Z\-]/).nil?

    location = m.message.split('!w ').last
    data     = JSON.parse(open_uri("http://api.openweathermap.org/data/2.5/find?q=#{location}&units=metric"))

    return if data['list'].empty?

    weather     = data['list'].first
    temp        = weather['main']['temp']
    description = weather['weather'].first['description']

    m.channel.notice("#{temp}ºC, #{description}")
  end

  private

  def open_uri(uri)
    curl = Curl::Easy.new
    curl.follow_location = true
    curl.useragent = "Ruby/#{RUBY_VERSION}"
    curl.url = uri

    curl.http_get
    curl.body_str
  end
end
