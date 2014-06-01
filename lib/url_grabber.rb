module UrlGrabber
  extend self

  def sanitize(str)
    words = str.split.map do |word|
      stripped_word = word.strip

      if stripped_word =~ /^www.[a-zA-Z0-9\-_]+.[a-zA-Z]+/
        "http://#{stripped_word}"
      else
        stripped_word
      end
    end.join(' ')
  end
end
