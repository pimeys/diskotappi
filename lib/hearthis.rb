require 'cinch'

require './lib/oembed_title_fetcher'

class Hearthis < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.hearthis.at hearthis.at)
  end

  def oembed(uri)
    "https://hearthis.at/oembed/?format=json&url=#{uri}"
  end
end
