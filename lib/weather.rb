# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'

class Weather
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!w/).nil?

    location = m.message.split('!w ').last

    if location == '!w'
      m.channel.notice("Berlin > Helsinki (toimii toimii)") and return if rand(100) == 99

      helsinki = JSON.parse(open_uri("http://api.openweathermap.org/data/2.5/find?q=helsinki&units=metric"))
      berlin   = JSON.parse(open_uri("http://api.openweathermap.org/data/2.5/find?q=berlin&units=metric"))

      temp_hki = helsinki['main']['temp'].to_f
      temp_bln = berlin['main']['temp'].to_f

      if temp_hki > temp_bln
        m.channel.notice("Helsinki #{temp_hki}ºC > Berlin #{temp_bln}ºC")
      else
        m.channel.notice("Berlin #{temp_bln}ºC > Helsinki #{temp_hki}ºC")
      end
    else
      data     = JSON.parse(open_uri("http://api.openweathermap.org/data/2.5/find?q=#{location}&units=metric"))

      return if data['list'].empty?

      weather     = data['list'].first
      place       = weather['name']
      temp        = weather['main']['temp']
      description = weather['weather'].first['description']

      m.channel.notice("#{place}: #{temp}ºC, #{description}")
    end
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
