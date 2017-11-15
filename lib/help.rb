# -*- coding: utf-8 -*-
require 'cinch'

class Help
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!help/).nil?

    m.channel.notice("https://github.com/pimeys/diskotappi/blob/master/README.md")
  end
end


