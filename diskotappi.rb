require 'cinch'

Dir['./lib/*.rb'].each { |file| require file }

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
