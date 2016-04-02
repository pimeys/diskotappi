require 'uri'
require 'cinch'
require 'nokogiri'

require './lib/oembed_title_fetcher'

class HsFi < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.hs.fi hs.fi)
  end

  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?

    uri = uris.first
    title = Nokogiri::HTML(OpenUri.(uri)).title.strip.split(" | ").first

    m.channel.notice("HS.fi :: #{title}")
  end
end

