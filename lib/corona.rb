# -*- coding: utf-8 -*-
require 'uri'
require 'json'
require 'curb'
require 'nokogiri'

class Corona
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!c/).nil?

    location = m.message.split('!c ').last
    
    if location == '!c'
      temp = fetch_corona_total
      return m.channel.notice("Corona error fetching data!") unless temp

      m.channel.notice("Corona totals. New confirmed: #{temp['Global']['NewConfirmed']}, total confirmed #{temp['Global']['TotalConfirmed']}, new deaths: #{temp['Global']['NewDeaths']}, total deaths: #{temp['Global']['TotalDeaths']}, new recovered: #{temp['Global']['NewRecovered']}, total recovered #{temp['Global']['TotalRecovered']}!")
    else
      
      location = location.strip.gsub(" ", "-")
      corona = fetch_corona(location)

      return m.channel.notice("Corona error fetching data!") unless corona

      temp = corona.last
      place       = temp['Country']
      confirmed   = temp['Confirmed']
      deaths      = temp['Deaths']
      recovered   = temp['Recovered']
      date_c      = temp['Date']

      m.channel.notice("Corona in #{place}, confirmed: #{confirmed}, deaths: #{deaths}, recovered: #{recovered}, date: #{date_c}")
    end
  end

  def fetch_corona_total
    JSON.parse(OpenUri.("https://api.covid19api.com/summary"))
  end

  def fetch_corona(country)
    #JSON.parse(OpenUri.("https://api.covid19api.com/live/country/#{country}/status/confirmed"))
    JSON.parse(OpenUri.("https://api.covid19api.com/dayone/country/#{country}"))
  end

end
