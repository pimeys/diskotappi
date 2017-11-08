require 'uri'
require 'json'
require 'curb'
require 'filesize'

class Giphy
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!giphy/).nil?

    mode = giphy_mode(m.message)
    params = "?api_key=#{config['api_key']}"

    if mode == :tag
      search = m.message.split("!giphy ").last
      params += "&tag=#{search}"
    end

    response = JSON.parse(OpenUri.("https://api.giphy.com/v1/gifs/random#{params}"))

    m.channel.notice("#{response['data']['image_mp4_url']}")
  end

  def giphy_mode(m)
    if m =~ /\A!giphy .+/
      :tag
    else
      :random
    end
  end

  protected

  def config
    return @config if @config

    @config = YAML.load_file("./config/giphy.yml")
  end
end
