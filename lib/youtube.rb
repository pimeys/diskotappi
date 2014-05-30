require 'cinch'

require './lib/oembed_title_fetcher'

class YouTube < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.youtube.com youtube.com)
  end

  def oembed(uri)
    "http://www.youtube.com/oembed?url=#{uri}"
  end
end
