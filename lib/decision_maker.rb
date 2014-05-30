require 'cinch'

class DecisionMaker
  include Cinch::Plugin

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

  def bot_name_regexp(nick)
    /^#{nick}[:,]*/
  end

  def bot_addressed?(message)
    !(message.message =~ bot_name_regexp(message.bot.nick)).nil?
  end

  def addressed_text(message)
    message.message.split(bot_name_regexp(message.bot.nick)).last.strip
  end
end
