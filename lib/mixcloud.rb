require 'cinch'
require './lib/oembed_title_fetcher'

class Mixcloud < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def allowed_hosts
    %w(mixcloud.com www.mixcloud.com)
  end

  def oembed(uri)
    "https://www.mixcloud.com/oembed?format=json&url=#{uri}"
  end
end
