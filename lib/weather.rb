# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'
require 'nokogiri'
require 'ale_air'
require 'influxdb'

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
      threads = ["helsinki,fi", "berlin,de", "amsterdam,nl"].reduce({}) do |acc, city|
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
      return m.channel.notice("Sompasauna, FI: data unavailable") unless temp

      m.channel.notice("Sompasauna, FI: temppeli: #{temp['temppeli']['temperature'].to_f}°C (päivitetty: #{temp['temppeli']['time']}) kappeli: #{temp['kappeli']['temperature'].to_f}°C (päivitetty: #{temp['kappeli']['time']})")
    elsif location == 'kertsi'
      temp = fetch_kertsi

      m.channel.notice(temp['result'])

    elsif air_quality_location
      temp = m.message.split('!w air ').last
      air_results = AleAir::FetchJSON.new(config['air_key'])

      air_results.air_quality(temp)
      return if air_results.status != "ok"

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
    JSON.parse(OpenUri.("https://api.openweathermap.org/data/2.5/weather?q=#{location}&units=metric&appid=#{config['api_key']}"))
  end

  def fetch_sauna
    influxdb.query('SELECT temperature FROM temppeli,kappeli ORDER BY DESC LIMIT 1').map { |x| { x['name'] => x['values'].first } }.inject(:merge)
  rescue
    nil
  end

  def fetch_kertsi
    JSON.parse(OpenUri.("https://api.particle.io/v1/devices/380036001047343432313031/diskotappi?access_token=#{config['kertsi_key']}"))
  end

  protected

  def influxdb
    @influxdb ||= InfluxDB::Client.new(host: 'mittari.sompasauna.fi', username: 'ro', password: 'ro', database: 'sompis', port: 443, use_ssl: true)
  end

  def config
    return @config if @config

    @config = YAML.load_file("./config/weather.yml")
  end
end
