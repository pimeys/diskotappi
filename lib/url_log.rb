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

    found      = Database.connection[:urllog].where(url: uris, channel: m.channel.name).all
    found_uris = found.map { |uri| uri[:url] }.to_set
    new_uris   = uris.select { |uri| !found_uris.include?(uri)}.map do |uri|
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
      m.reply("#{m.user.nick}, wanha!")
    end
  end
end
