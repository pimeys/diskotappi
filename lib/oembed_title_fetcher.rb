require 'uri'
require 'json'
require 'open-uri'

class OembedTitleFetcher
  def listen(m)
    uris = URI.extract(m.message).select do |uri|
      allowed_hosts.include?(URI.parse(uri).host)
    end

    return if uris.empty?

    titles = uris.map do |uri|
      json = JSON.parse(open(oembed(uri)).read)

      json['title']
    end

    m.channel.notice("#{self.class.name} :: #{titles.join(' // ')}")
  end
end
