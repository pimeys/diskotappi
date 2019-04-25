# -*- coding: utf-8 -*-
require 'cinch'
require 'sequel'

require './lib/bot_helper'
require './lib/database'

class Quote
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!q/).nil?

    dataset = Database.connection[:quotes]

    if quote_mode(m.message) == :add
      text = m.message.split(' add ').last

      return if dataset.where(text: text).count > 0

      nick_with_rubbish = /(<[^>]+>)/.match(text)[0]
      nick = /((?:[A-z0-9_-]+))/.match(nick_with_rubbish)[0]

      dataset.insert(text: text, adder: m.user.nick, nick: nick)

      m.reply("#{m.user.nick}, Quote added")
    elsif quote_mode(m.message) == :named_random
      search = m.message.split('!q ').last
      text   = dataset.select(:text).where(Sequel.like(:text, Regexp.new(search))).
               order { rand{} }.first

      m.channel.notice(text[:text]) if text
    else
      text = dataset.select(:text).order(Sequel.lit('RANDOM()')).first

      m.channel.notice(text[:text]) if text
    end
  end

  def quote_mode(message)
    if message =~ /\A!q add (<[^>]+>) .+/
      :add
    elsif message =~ /\A!q .+/
      :named_random
    else
      :random
    end
  end
end
