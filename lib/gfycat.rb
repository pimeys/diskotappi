require 'uri'
require 'json'
require 'curb'
require 'filesize'

class GfyCat
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    uri = parse_uris(m).first

    return if uri.nil?

    uri        = uri.split('://').last
    rnd_string = (0...8).map { (65 + rand(26)).chr }.join

    curl = Curl::Easy.new
    curl.useragent = "Ruby/#{RUBY_VERSION}"
    curl.url = "http://upload.gfycat.com/transcode/#{rnd_string}?fetchUrl=#{uri}"

    curl.http_get

    response = JSON.parse(curl.body_str)
    gfy_uri  = "http://gfycat.com/#{response['gfyName']}"
    gfy_size = Filesize.from("#{response['gfysize']} B").pretty
    gif_size = Filesize.from("#{response['gifSize']} B").pretty

    m.channel.notice("GIF :: Size: #{gif_size}, HTML5: #{gfy_uri}, Size: #{gfy_size}")
  end

  private

  def parse_uris(m)
    message = UrlGrabber.sanitize(m.message)

    begin
      URI.extract(message).select do |uri|
        uri =~ /.gif$/
      end
    rescue URI::InvalidURIError
      []
    end
  end
end
