# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'
require 'nokogiri'
require 'ale_air'

class Weather
  include Cinch::Plugin

  listen_to :channel

  def initialize(bot)
    @bot      = bot
    @handlers = []
    @timers   = []

    __register
  end

  def listen(m)
    return if (m.message =~ /\A!w/).nil?

    location = m.message.split('!w ').last
    air_quality_location = m.message.include? " air "

    if location == '!w'
      threads = ["helsinki,fi", "berlin,de", "london,uk"].reduce({}) do |acc, city|
        acc[city] = Thread.new { Thread.current[:weather] = fetch_weather(city) }

        acc
      end

      threads.values.each(&:join)

      unsorted = threads.map do |city, thread|
        weather = thread[:weather]
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

    elsif air_quality_location
      temp = m.message.split('!w air ').last
      air_results = AleAir::FetchJSON.new(config['air_key'])
      
      return if !air_results.air_quality(temp)

      m.channel.notice(air_results.irc_string)
    
    else
      weather = fetch_weather(location)

      return if weather['cod'] != 200

      place       = weather['name']
      temp        = weather['main']['temp']
      temp_min    = weather['main']['temp_min']
      temp_max    = weather['main']['temp_max']
      description = weather['weather'].first['description']

      country     = weather['sys']['country']

      m.channel.notice("#{place}, #{country}: #{temp}°C (#{temp_min}°C-#{temp_max}°C), #{description}")
    end
  end

  def fetch_weather(location)
    JSON.parse(OpenUri.("http://api.openweathermap.org/data/2.5/weather?q=#{location}&units=metric&appid=#{config['api_key']}"))
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
