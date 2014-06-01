require 'cinch'

require './lib/youtube'
require './lib/soundcloud'
require './lib/decision_maker'
require './lib/genre_generator'
require './lib/url_log'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.net'
    c.channels = ['#juliusbot']
    c.nick = 'diskotappi'
    c.plugins.plugins = [YouTube, SoundCloud, DecisionMaker, GenreGenerator, UrlLog]
  end
end

bot.start
