# -*- coding: utf-8 -*-
require 'cinch'

class Ei
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!ei/).nil?

    m.channel.notice("<@TheH> ei")
  end
end

