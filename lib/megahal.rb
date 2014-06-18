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

    longreply = hal.doreply(addressed_text).force_encoding('ISO-8859-1').encode('UTF-8')
    phrases   = longreply.split(/[\.\?\!\,]/).map(&:strip)
    phrase1   = phrases[Random.rand(phrases.size)].split(' ')
    phrase2   = phrases[Random.rand(phrases.size)].split(' ')
    part1     = phrase1[0..(phrase1.size / 2)].join(' ')
    part2     = phrase2[(phrase2.size / 2)..(phrase2.size)].join(' ')

    hal.learn(addressed_text.encode('ISO-8859-1'))

    m.reply("#{m.user.nick}: #{part1} #{part2}.")
  end
end
