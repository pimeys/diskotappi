require 'uri'
require 'cinch'
require 'nokogiri'

require './lib/oembed_title_fetcher'

class ResidentAdvisor < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.residentadvisor.net residentadvisor.net)
  end

  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?

    uri = uris.first
    title = Nokogiri::HTML(OpenUri.(uri)).title.strip

    m.channel.notice(title)
  end
end
