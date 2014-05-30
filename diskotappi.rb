require 'cinch'

require './lib/youtube'
require './lib/soundcloud'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.net'
    c.channels = ['#juliusbot']
    c.nick = 'diskotappi'
    c.plugins.plugins = [YouTube, SoundCloud]
  end
end

bot.start
