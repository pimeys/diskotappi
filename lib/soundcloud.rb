require 'cinch'

require './lib/oembed_title_fetcher'

class Soundcloud < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.soundcloud.com soundcloud.com)
  end

  def oembed(uri)
    "https://www.soundcloud.com/oembed?format=json&url=#{uri}"
  end
end
