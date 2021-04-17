require 'cinch'

require './lib/oembed_title_fetcher'

class YouTube < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(m.youtube.com www.youtube.com youtube.com youtu.be)
  end

  def oembed(uri)
    "https://www.youtube.com/oembed?url=#{uri}"
  end
end
