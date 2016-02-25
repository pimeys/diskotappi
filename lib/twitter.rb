require 'uri'
require 'cgi'
require 'json'
require 'cinch'
require 'nokogiri'

require './lib/oembed_title_fetcher'

class Twitter < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.twitter.com twitter.com)
  end

  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?

    escaped_tweet_uri = CGI.escape(uris.first)
    uri               = "https://api.twitter.com/1/statuses/oembed.json?url=#{escaped_tweet_uri}"
    tweet             = JSON.parse(OpenUri.(uri))["html"].gsub("&mdash;", " &mdash;")
    tweet_text        = Nokogiri::HTML(tweet).text.strip

    m.channel.notice("#{self.class.name} :: #{tweet_text}")
  end
end
