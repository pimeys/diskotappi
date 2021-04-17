require 'cinch'

require './lib/oembed_title_fetcher'

class Vimeo < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.vimeo.com vimeo.com)
  end

  def oembed(uri)
    "https://vimeo.com/api/oembed.json?url=#{uri}"
  end
end
