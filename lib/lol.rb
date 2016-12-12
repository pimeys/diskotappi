# -*- coding: utf-8 -*-
require 'cinch'

class Lol
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!:D/).nil?

    m.channel.notice("http://giphy.com/gifs/tMyCJmeXHBetq/html5")
  end
end
