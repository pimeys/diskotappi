require 'cinch'

require './lib/oembed_title_fetcher'

class Spotify
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    uris = parse_uris(m)

    return if uris.empty?

    titles = uris.map do |uri|
      json = JSON.parse(open_spotify_uri(uri[:type], uri[:uri]))

      require 'pry'
      binding.pry

      artist = json['artists'].size > 1 ? 'V/A' : json['artists'].first['name']
      title  = json['name']

      "#{artist}: #{title}"
    end

    m.channel.notice("#{self.class.name} :: #{titles.join(' // ')}")
  end

  private

  def uri_type(uri)
    if uri =~ /^spotify:artist:[a-zA-Z0-9]+/
      :spotify_artist_uri
    elsif uri =~ /^spotify:album:[a-zA-Z0-9]+/
      :spotify_album_uri
    elsif uri =~ /^spotify:track:[a-zA-Z0-9]+/
      :spotify_track_uri
    elsif %(open.spotify.com).include?(URI.parse(uri).host)
      :spotify_url
    else
      nil
    end
  end

  def open_spotify_uri(type, uri)
    case type
    when :spotify_track_uri
      track_id = uri.split(':').last

      open_uri("https://api.spotify.com/v1/tracks/#{track_id}")
    when :spotify_album_uri
      album_id = uri.split(':').last

      open_uri("https://api.spotify.com/v1/album/#{album_id}")
    when :spotify_artist_uri
      artist_id = uri.split(':').last

      open_uri("https://api.spotify.com/v1/artist/#{album_id}")
    when :spotify_url
      _, type, id = URI.parse(uri).path.split('/')

      type = "tracks" if type == "track"

      open_uri("https://api.spotify.com/v1/#{type}/#{id}")
    else
      raise ArgumentError.new("Unsupported uri type: #{type}")
    end
  end

  def open_uri(uri)
    curl = Curl::Easy.new
    curl.follow_location = true
    curl.useragent = "Ruby/#{RUBY_VERSION}"
    curl.url = uri

    curl.http_get
    curl.body_str
  end

  def parse_uris(m)
    message = UrlGrabber.sanitize(m.message)

    begin
      URI.extract(message).map do |uri|
        { type: uri_type(uri), uri: uri }
      end
    rescue URI::InvalidURIError
      []
    end
  end
end
