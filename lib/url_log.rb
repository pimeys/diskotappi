# -*- coding: utf-8 -*-
require 'cinch'

require './lib/bot_helper'
require './lib/url_grabber'
require './lib/database'

class UrlLog
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    message = UrlGrabber.sanitize(m.message)

    uris = URI.extract(message).reduce([]) do |acc, uri_str|
      begin
        acc << URI.parse(uri_str).to_s
      rescue URI::InvalidURIError
      ensure
        acc
      end
    end

    return if uris.empty?

    found      = Database.connection[:urllog].where(url: uris, channel: m.channel.name).exclude(nick: m.user.nick).all
    found_uris = found.map { |uri| uri[:url] }.to_set
    new_uris   = uris.select { |uri| !found_uris.include?(uri) }.map do |uri|
      {
        url: uri,
        nick: m.user.nick,
        userhost: m.user.mask.mask,
        comment: uri,
        channel: m.channel.name,
        entrydate: Time.now
      }
    end

    Database.connection[:urllog].multi_insert(new_uris) unless new_uris.empty?

    found.each do |found|
      diff = time_in_words(Time.now - found[:entrydate])

      m.reply("#{m.user.nick}, wanha, #{found[:nick]} pastes jo #{diff} sitten")
    end
  end

  def time_in_words(seconds)
    if seconds >= time_conversions[:year_in_seconds]
      years = (seconds / time_conversions[:year_in_seconds]).to_i
      days  = (seconds % time_conversions[:year_in_seconds] / time_conversions[:day_in_seconds]).to_i

      if years == 1
        days <= 1 ? 'vuosi ja yksi päivä' : "vuosi ja #{days} päivää"
      else
        days <= 1 ? '#{years} vuotta ja yksi päivä' : "#{years} vuotta ja #{days} päivää"
      end
    elsif seconds >= time_conversions[:day_in_seconds]
      days = (seconds / time_conversions[:day_in_seconds]).to_i

      days == 1 ? 'päivä' : "#{days} päivää"
    elsif seconds >= time_conversions[:hour_in_seconds]
      hours = (seconds / time_conversions[:hour_in_seconds]).to_i

      hours == 1 ? 'tunti' : "#{hours} tuntia"
    elsif seconds >= time_conversions[:minute_in_seconds]
      minutes = (seconds / time_conversions[:minute_in_seconds]).to_i

      minutes == 1 ? 'minuutti' : "#{minutes} minuuttia"
    else
      'melkein minuutti'
    end
  end

  private

  def time_conversions
    @time_conversions ||= {
      minute_in_seconds: 60,
      hour_in_seconds: 60 * 60,
      day_in_seconds: 60 * 60 * 24,
      year_in_seconds: 60 * 60 * 24 * 365
    }
  end
end
