require 'cinch'

require './lib/bot_helper'

class DecisionMaker
  include Cinch::Plugin
  include BotHelper

  listen_to :channel

  def decision_regexp
    /^kumpi[:,]* \w+/
  end

  def listen(message)
    return unless bot_addressed?(message)

    addressed_text = addressed_text(message)

    return unless addressed_text =~ decision_regexp

    options = addressed_text.split(decision_regexp).last.split(' vai' ).map(&:strip)

    return unless options.size == 2

    result = case rand(100)
             when 99
               'molemmat'
             when 98
               'ei kumpikaan'
             when lambda { |dice| dice >= 49 }
               options.first
             else
               options.last
             end

    message.reply("#{message.user.nick}: #{result}")
  end
end
