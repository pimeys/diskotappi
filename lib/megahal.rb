require 'cinch'

require './lib/bot_helper'
require './lib/megahal/Hal'

class MegaHal
  include Cinch::Plugin
  include BotHelper

  listen_to :channel

  attr_reader :hal

  def initialize(bot)
    @bot      = bot
    @hal      = Hal.new
    @handlers = []
    @timers   = []

    @hal.initbrain
    __register
  end

  def listen(m)
    return unless bot_addressed?(m)

    addressed_text = addressed_text(m)

    return if addressed_text =~ /^kumpi \w+/
    return if addressed_text =~ /^genre \w+/

    m.reply("#{m.user.nick}: #{hal.doreply(addressed_text)}")
  end
end
