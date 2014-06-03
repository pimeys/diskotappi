require 'uri'
require 'json'
require 'curb'

class OembedTitleFetcher
  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?

    titles = uris.map do |uri|
      json = JSON.parse(open_uri(oembed(uri)))

      json['title']
    end

    m.channel.notice("#{self.class.name} :: #{titles.join(' // ')}")
  end

  protected

  def parse_uris(m)
    message = UrlGrabber.sanitize(m.message)

    begin
      URI.extract(message).select do |uri|
        allowed_hosts.include?(URI.parse(uri).host)
      end
    rescue URI::InvalidURIError
      []
    end
  end

  private

  def open_uri(uri)
    curl = Curl::Easy.new
    curl.follow_location = true
    curl.useragent = "Ruby/#{RUBY_VERSION}"
    curl.url = uri

    curl.http_get
    curl.body_str
  end
end
