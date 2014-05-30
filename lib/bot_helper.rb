module BotHelper
  def bot_name_regexp(bot)
    /^#{bot.nick}[:,]*/
  end

  def bot_addressed?(message)
    !(message.message =~ bot_name_regexp(message.bot)).nil?
  end

  def addressed_text(message)
    message.message.split(bot_name_regexp(message.bot)).last.strip
  end
end
