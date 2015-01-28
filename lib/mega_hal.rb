# -*- coding: utf-8 -*-
require 'cinch'
require 'megahal'

require './lib/bot_helper'

class MegaHal
  include Cinch::Plugin
  include BotHelper

  listen_to :channel

  attr_reader :hal

  MegaHAL::ANTONYMS = File.readlines('./lib/personalities/diskotappi.swp').map do |swp|
    swp.strip.split("\t")
  end

  MegaHAL::GREETING = ["HUHUU", "MOI", "HEI", "MOIKKAMOI"]
  MegaHAL::AUXILIARY = File.readlines('./lib/personalities/diskotappi.aux').map(&:strip)
  MegaHAL::BANNED = File.readlines('./lib/personalities/diskotappi.ban').map(&:strip)

  MegaHAL.add_personality(:diskotappi, File.read('./lib/personalities/diskotappi.trn'))

  def initialize(bot)
    @bot      = bot
    @hal      = MegaHAL.new
    @handlers = []
    @timers   = []

    @hal.become(:diskotappi)
    @hal.train('./lib/personalities/diskotappi.phr')

    __register
  end

  def listen(m)
    return unless bot_addressed?(m)

    addressed_text = addressed_text(m)

    return if addressed_text =~ /^kumpi[:,] \w+/
    return if addressed_text =~ /^genre \w+/

    longreply1 = hal.reply(addressed_text)
    longreply2 = hal.reply(addressed_text)
    phrases1   = longreply1.split(/[\.\?\!\,]/).map(&:strip)
    phrases2   = longreply2.split(/[\.\?\!\,]/).map(&:strip)
    phrase1    = phrases1[Random.rand(phrases1.size)].split(' ')
    phrase2    = phrases2[Random.rand(phrases2.size)].split(' ')
    part1      = phrase1[0..(phrase1.size / 2)]
    part2      = phrase2[(phrase2.size / 2)..(phrase2.size)]
    reply      = part1.last == part2.first ? part1[0..-2] + part2 : part1 + part2

    m.reply("#{m.user.nick}: #{reply.join(' ')}.")
  end
end
