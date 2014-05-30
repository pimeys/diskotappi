require 'cinch'

require './lib/youtube'
require './lib/soundcloud'
require './lib/decision_maker'
require './lib/genre_generator'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.net'
    c.channels = ['#juliusbot']
    c.nick = 'diskotappi'
    c.plugins.plugins = [YouTube, SoundCloud, DecisionMaker, GenreGenerator]
  end
end

bot.start
