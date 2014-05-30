require 'cinch'

require './lib/bot_helper'

class DecisionMaker
  include Cinch::Plugin
  include BotHelper

  listen_to :channel

  def listen(message)
    return unless bot_addressed?(message)

    addressed_text = addressed_text(message)

    return unless addressed_text =~ /^kumpi \w+/

    options = addressed_text.split('kumpi').last.split(' vai' ).map(&:strip)

    return unless options.size == 2

    dice = rand(100)

    if dice == 98
      result = 'ei kumpikaan'
    elsif dice == 99
      result = 'molemmat'
    elsif dice < 49
      result = options.first
    else
      result = options.last
    end

    message.reply("#{message.user.nick}: #{result}")
  end
end
