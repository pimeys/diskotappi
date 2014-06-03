require 'cinch'

require './lib/oembed_title_fetcher'

class Spotify < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(open.spotify.com)
  end

  def oembed(uri)
    "https://embed.spotify.com/oembed?url=#{uri}"
  end

  protected

  def parse_uris(m)
    message = UrlGrabber.sanitize(m.message)

    begin
      URI.extract(message).select do |uri|
        allowed_hosts.include?(URI.parse(uri).host) || uri =~ /^spotify:[a-z]+:[a-zA-Z0-9]+/
      end
    rescue URI::InvalidURIError
      []
    end
  end
end
