require 'cinch'

require './lib/youtube'
require './lib/soundcloud'
require './lib/mixcloud'
require './lib/spotify'
require './lib/decision_maker'
require './lib/genre_generator'
require './lib/url_log'
require './lib/megahal'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.net'
    c.channels = ['#juliusbot']
    c.nick = 'diskotappi'
    c.plugins.plugins = [YouTube, SoundCloud, Spotify, Mixcloud,
                         DecisionMaker, GenreGenerator, UrlLog,
                         MegaHal]
  end
end

bot.start
