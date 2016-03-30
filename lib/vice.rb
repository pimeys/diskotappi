require 'cinch'

require './lib/vice_dict.rb'

class Vice
  include Cinch::Plugin
  include ViceDict

  listen_to :channel

  def listen(m)
    return if (m.message =~ /\A!vice/).nil?

    m.channel.notice("VICE: #{phrases.sample}")
  end

  private

  def phrases
    [
      HOW_WHY.sample + " " + PLACE.sample + "\'s " + OCCUPATION.sample + "s " + "are " +
        SWAPPING.sample + " " + OBJECT1.sample + "s " + "for " + OBJECT2.sample + "s",

      WE.sample + " Spent " + TIME.sample + " " + SCENARIO.sample + " with " + PLACE.sample +
        "\'s " + OCCUPATION.sample + "s", DRUG_TAKING.sample + " " + DRUG.sample + " " +
        SCENARIO.sample + " with " + PERSON.sample,

      "A " + STATUS_RELIGION_NATIONALITY.sample + " " + OCCUPATION.sample + "\'s " +
        GUIDE.sample + " " + PLACE.sample,

      OBJECT1.sample + "s, " + OBJECT2.sample + "s and " + DRUG.sample + ": " +
        SCENARIO.sample + " with " + PERSON.sample + " in " + PLACE.sample,

      "Is the " + NATIONALITY.sample + " " + GENRE.sample + " " + MUSIC_SCENE.sample +
        " " + CHANGING.sample + "?",

      TIME.sample + " with " + PERSON.sample + " and a " + NATIONALITY.sample + " " +
        OCCUPATION.sample,

      PERSON.sample + "\'s " + FAMILY_MEMBER.sample + " is Not a " + OCCUPATION1.sample +
        ", But He is a " + OCCUPATION2.sample,

      "Do " + OCCUPATION.sample + "s Really Need " + OBJECT.sample + "s? This " +
        NATIONALITY.sample + " " + GENRE.sample + " Fan " + ANSWER.sample,

      "We\'re " + DEBATING.sample + " " + DRUG_TAKING1.sample + " " + DRUG1.sample +
        " vs. " + DRUG_TAKING2.sample + " " + DRUG2.sample + " with " + PERSON.sample,

      "Meet the " + STATUS_RELIGION_NATIONALITY.sample + " " + OCCUPATION.sample +
        "s Who Are Putting " + GENRE.sample + " Back on the Map",

      "I " + LIVED.sample + " a " + OCCUPATION.sample + " in " + PLACE.sample +
        " and There Was No " + PERSON.sample,

      DISCOVER.sample + " What " + HAPPENED.sample + " When We Were " + SCENARIO.sample +
        " for " + TIME.sample + " in " + PLACE.sample,

      "We\'re " + DRUG_TAKING.sample + " " + DRUG.sample + " with " + PLACE.sample +
        "\'s " + OCCUPATION.sample + "s",

      "Next Month, " + PERSON.sample + " Spends " + TIME.sample + " With a " +
        OBJECT.sample + ", " + DRUG_TAKING.sample + " " + DRUG.sample,

      "This is the " + STATUS_RELIGION_NATIONALITY.sample + " " + OCCUPATION.sample +
        " Who Wants to Make " + PLACE1.sample + " the New " + PLACE2.sample,

      PERSON.sample + ": " + HOW_WHY.sample + " a " + OBJECT.sample + " Couldn\'t " +
        SAVE.sample + " My " + FAMILY_MEMBER.sample + " From Overdosing on " + DRUG.sample + " in " + PLACE.sample,

      HOW_WHY.sample + " " + PERSON1.sample + " thought " + PERSON2.sample + " was a " +
        STATUS_RELIGION.sample + " " + OCCUPATION.sample,

      HOW_WHY.sample + " " + PLACE.sample + "\'s " + COOLEST.sample + " " + BAND.sample +
        " Have Already " + GIGGED.sample + " Next Year\'s " + FESTIVAL.sample,

      DRUG_TAKING.sample + " " + DRUG.sample + " at " + FESTIVAL.sample + ": " + ARTICLE_TYPE.sample,

      "Meet the Writers Behind " + PLACE.sample + "\'s Version of " + TV_SHOW.sample,

      HOW_WHY.sample + " " + PLACE.sample + "\'s Answer to " + TV_SHOW.sample +
        " Is Just " + PERSON.sample + " on " + DRUG.sample,

      AGE.sample + " and " + SEXUAL_ORIENTATION.sample + ": " + PLACE.sample + "\'s " +
        OCCUPATION.sample + "s",

      AMOUNT.sample + " Reasons Why " + PLACE_FESTIVAL.sample + " is the " + WORST.sample,

      WE.sample + " " + PAIN.sample + " " + PERSON.sample + " and " + SOCIAL_MEDIA_ACTION.sample,

      WE.sample + " " + FOUND.sample + " " + PERSON.sample + " and a " + RELIGION.sample + " " +
        OCCUPATION.sample + " " + DOING_BAD.sample + " Each Other",

      HOW_WHY.sample + " Being a " + NATIONALITY.sample + " " + SEXUAL_ORIENTATION_RELIGION.sample +
        " Got Me a Role on " + TV_SHOW.sample,

      HOW_WHY.sample + " " + PLACE.sample + "\'s Version of " + SOCIAL_NETWORK.sample +
        " is " + FRONT.sample + " " + PAIN.sample + " " + OCCUPATION.sample + "s",

      WE.sample + " " + WENT.sample + " " + PLACE_FESTIVAL.sample + " and " +
        BOUGHT_SOLD.sample + " " + FAKE.sample + " " + DRUG.sample + " " + REASON.sample,

      WE.sample + " " + FOUND.sample + " a " + SEXUAL_ORIENTATION_RELIGION.sample + " " +
        OCCUPATION.sample + " and didn\'t " + SAVE.sample + " them from " +
        DOING_BAD.sample + " " + PERSON.sample,

      WE.sample + " " + MET.sample + " a " + HUMAN.sample + " on " +
        SOCIAL_NETWORK.sample +  " who " + WENT.sample + " " + PLACE_FESTIVAL.sample +
        " and " + PAIN.sample + " their " + FAMILY_MEMBER.sample,

      "I " + LIVED.sample + " " + MEMBER.sample + " of " + GANG.sample,

      HOW_WHY.sample + " a " + OCCUPATION.sample + " " + GROUP.sample + " are the " +
        COOLEST.sample + " " + GENRE.sample + " " + BAND.sample + " in " + PLACE.sample,
    ]
  end
end
