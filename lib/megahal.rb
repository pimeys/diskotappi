# -*- coding: utf-8 -*-
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

    addressed_text = addressed_text(m).encode('ISO-8859-1')

    return if addressed_text =~ /^kumpi \w+/
    return if addressed_text =~ /^genre \w+/

    reply = hal.doreply(addressed_text).force_encoding('ISO-8859-1').encode('UTF-8')

    hal.learn(addressed_text.encode('ISO-8859-1'))

    m.reply("#{m.user.nick}: #{reply}")
  end
end
