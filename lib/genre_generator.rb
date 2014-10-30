# -*- coding: utf-8 -*-
require 'cinch'

require './lib/bot_helper'

class GenreGenerator
  include Cinch::Plugin
  include BotHelper

  listen_to :channel

  def listen(message)
    return unless bot_addressed?(message)

    addressed_text = addressed_text(message)

    return unless addressed_text =~ /^genre \w+/

    given_genre = addressed_text.split('genre').last.strip.split
    mains       = main_genres.select { |genre| !given_genre.include?(genre) }
    subs        = subgenres.select   { |genre| !given_genre.include?(genre) }
    main_dice   = genre_rand(0, mains.size - 1)
    sub_dice1   = genre_rand(0, subs.size - 1)
    sub_dice2   = genre_rand(0, subs.size - 1)

    generated   = [subs[sub_dice1], subs[sub_dice2], mains[main_dice]]
    replace_at  = genre_rand(0, generated.join(' ').split.size - 1)

    generated.insert(replace_at, given_genre.join(' '))

    message.reply("#{message.user.nick}: #{generated.join(' ')}")
  end

  private

  def genre_rand(min, max)
    (min + (rand * (max - min + 1)).floor).round.to_i
  end

  def main_genres
    [ "house", "trance", "ambient", "techno", "triphop", "hardcore", "rave", "drum'n'bass",
      "jungle", "goa", "kiksu", "disco", "acid", "electro", "dub", "nitku", "dubstep" ]
  end

  def subgenres
    [ "kiksu", "kamppi", "kerava", "amis", "suomi", "tyttö", "italo", "synth", "garage", "classic", "acid",
      "hip", "freestyle", "vocal", "anthem", "euro", "happy", "jpop", "goth", "death", "epic", "nrg",
      "speed", "hard", "booty", "minimal", "latin", "deep", "funky", "industrial", "experimental",
      "intelligent", "futuristic", "psychedelic", "goa", "hardstyle", "german", "french", "ibiza",
      "progressive", "dubby", "tribal", "swedish", "brit", "gangsta", "soulful", "ghetto", "oldskool",
      "nuskool", "jazzstep", "liquid", "neuro", "dark", "ill", "wobble", "hipster", "jytky", "viuhka"
    ]
  end
end
