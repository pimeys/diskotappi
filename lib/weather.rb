# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'
require 'dalli'

class Weather
  include Cinch::Plugin

  listen_to :channel

  def initialize(bot)
    @bot      = bot
    @handlers = []
    @timers   = []
    @cache    = Dalli::Client.new('localhost:11211', compress: true, expires_in: 60 * 15)

    __register
  end

  def listen(m)
    return if (m.message =~ /\A!w/).nil?

    location = m.message.split('!w ').last

    if location == '!w'
      threads = [:helsinki, :berlin].reduce({}) do |acc, city|
        acc[city] = Thread.new { Thread.current[:weather] = fetch_weather(city) }

        acc
      end

      threads.values.each(&:join)

      helsinki = threads[:helsinki][:weather]
      berlin   = threads[:berlin][:weather]

      temp_hki = helsinki['list'].first['main']['temp'].to_f
      temp_bln = berlin['list'].first['main']['temp'].to_f

      if temp_hki > temp_bln
        m.channel.notice("Helsinki #{temp_hki}°C > Berlin #{temp_bln}°C")
      else
        m.channel.notice("Berlin #{temp_bln}°C > Helsinki #{temp_hki}°C")
      end
    else
      data = fetch_weather(location)

      return if data['list'].empty?

      weather     = data['list'].first
      place       = weather['name']
      temp        = weather['main']['temp']
      description = weather['weather'].first['description']

      country     = weather['sys']['country']

      m.channel.notice("#{place}, #{country}: #{temp}°C, #{description}")
    end
  end

  def fetch_weather(location)
    @cache.fetch("weather-#{location}") do
      JSON.parse(OpenUri.("http://api.openweathermap.org/data/2.5/find?q=#{location}&units=metric"))
    end
  end
end
