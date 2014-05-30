require 'cinch'

require './lib/youtube'
require './lib/soundcloud'
require './lib/decision_maker'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.net'
    c.channels = ['#juliusbot']
    c.nick = 'diskotappi'
    c.plugins.plugins = [YouTube, SoundCloud, DecisionMaker]
  end
end

bot.start
