require 'cinch'

require './lib/oembed_title_fetcher'

class SoundCloud < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(www.soundcloud.com soundcloud.com)
  end

  def oembed(uri)
    "http://www.soundcloud.com/oembed?format=json&url=#{uri}"
  end
end
