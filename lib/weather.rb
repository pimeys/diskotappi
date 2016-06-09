# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'
require 'dalli'
require 'nokogiri'

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
      threads = ["helsinki,fi", "berlin,de", "london,uk"].reduce({}) do |acc, city|
        acc[city] = Thread.new { Thread.current[:weather] = fetch_weather(city) }

        acc
      end

      threads.values.each(&:join)

      unsorted = threads.map do |city, thread|
        weather = thread[:weather]['list'].first
        { city: weather['name'], temp: weather['main']['temp'].to_f }
      end

      sorted = unsorted.sort_by { |city| -city[:temp] }

      rendered = sorted.map { |city| "#{city[:city]} #{city[:temp]}°C"}

      m.channel.notice(rendered.join(" > "))
    elsif location == 'sompasauna'
      temp = fetch_sauna

      m.channel.notice("Sompasauna, FI: #{temp['value']}°C (päivitetty: #{temp['timestamp']})")
    elsif location == 'kertsi'
      temp = fetch_kertsi

      m.channel.notice(temp['result'])
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
      JSON.parse(OpenUri.("http://api.openweathermap.org/data/2.5/find?q=#{location}&units=metric&appid=#{config['api_key']}"))
    end
  end

  def fetch_sauna
    JSON.parse(OpenUri.("http://sompasauna.fi/lampotila/index.php/on/saunassa?format=json"))
  end

  def fetch_kertsi
    JSON.parse(OpenUri.("https://api.particle.io/v1/devices/380036001047343432313031/diskotappi?access_token=#{config['kertsi_key']}"))
  end

  protected

  def config
    return @config if @config

    @config = YAML.load_file("./config/weather.yml")
  end
end
