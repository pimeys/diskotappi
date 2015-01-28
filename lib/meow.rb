class Meow
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    feeding = m.message =~ /\A!feed/

    if feeding && hungry?
      @fed       = Time.now.utc

      m.reply("#{m.user.nick}: *purrrr* (mumps)")
    elsif hungry? && rand(100) < annoyance
      m.reply("#{m.user.nick}: #{meow}")
    end
  end

  def annoyance
    15 # 0 (no begging) - 100 (constant begging)
  end

  def feeding_hours # utc
    Set.new([8, 22])
  end

  def feeding_hour?
    feeding_hours.include?(Time.now.utc.hour)
  end

  def hungry?
    feeding_hour? && !fed_recently?
  end

  def fed_recently?
    @fed &&
      @fed.hour == Time.now.utc.hour &&
      @fed.day == Time.now.utc.day &&
      @fed.month == Time.now.utc.month
  end

  def meow
    @voices ||= [
      '*miau* *miau*',
      '*purrrrr*',
      '*miau*',
      '*mouuuu*',
      '*kur*'
    ]

    @voices[rand(@voices.size)]
  end
end
