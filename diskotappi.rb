require 'cinch'

require './lib/youtube'
require './lib/soundcloud'
require './lib/mixcloud'
require './lib/spotify'
require './lib/decision_maker'
require './lib/genre_generator'
require './lib/url_log'
require './lib/megahal'
require './lib/gfycat'
require './lib/weather'
require './lib/vimeo'

bot = Cinch::Bot.new do
  config = YAML.load_file('./config/diskotappi.yml')

  configure do |c|
    c.server = config['server']
    c.channels = config['channels']
    c.nick = config['nick']
    c.user = config['user']
    c.realname = config['realname']
    c.plugins.plugins = config['plugins'].map { |p| Kernel.const_get(p) }
  end
end

bot.start
