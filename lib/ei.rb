# -*- coding: utf-8 -*-
require 'cinch'

class Ei
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!ei/).nil?

    nick = ["<@TheH>", "<@eltron>"][rand(2)]

    m.channel.notice("#{nick} ei")
  end
end

