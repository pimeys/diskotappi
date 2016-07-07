require 'cinch'

require './lib/oembed_title_fetcher'

class YouTube < OembedTitleFetcher
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?
    uri = uris.first
    title = JSON.parse(OpenUri.(oembed(uri)))['title']

    video_id = if uri =~ /youtu.be/
                 uri.split("/").last
               else
                 uri.split("?v=").last
               end

    nsfw_uri = "http://www.nsfwyoutube.com/watch?v=#{video_id}"

    m.channel.notice("#{self.class.name} :: #{title} (#{nsfw_uri})")
  end

  def allowed_hosts
    %w(m.youtube.com www.youtube.com youtube.com youtu.be)
  end

  def oembed(uri)
    "http://www.youtube.com/oembed?url=#{uri}"
  end
end
