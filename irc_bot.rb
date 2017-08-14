###############################################
# Implement your own ideas below this comment #
###############################################

require 'uri'

@name = "sh^tty_siri"

def send_to_channel(message)
  irc_send("PRIVMSG #{@channel} :#{message}")
end

def parse_message(message)
  # :nethad!~nethad@2a02:168:4a98:0:4685:ff:fe64:de8 PRIVMSG #rubymonstas :asdf
  parts = message.split("#{@channel} :")
  nick  = parts[0].split("!")[0][1..-1]
  {
    nick: nick,
    message: parts[1]
  }
end

# This method gets called, whenever a message is sent to our IRC channel. In it you can react to
# the users' inputs in whatever way you like...
def handle_channel_message(message)
  parsed = parse_message(message)
  m = parsed[:message].downcase

  sleep 1 # so it looks like Shitty Siri has to think... :-)

  if m.start_with?("hey siri") || @hey_siri_response_given
    if m.include?("weather") || m.include?("rain") || m.include?("sunny")
      send_to_channel("I wouldn't know, I'm a Ruby script. It's August, I'd say it's probably sunny.")
    elsif m.include?("monstas")
      send_to_channel("RubyMonstas is a weekly programming course for women, you can find more information on http://rubymonstas.ch/")
    elsif m.include?("thank you")
      send_to_channel("You're most welcome. That'll make $10.")
    elsif m.include?("don't") && m.include?("money")
      send_to_channel("Tough luck, you think I work for free? Besides that, do you really think I forgot I already have your credit card information?")
    else
      send_to_channel("I'm sorry, I didn't understand you. Whatever, here's a link to the web: https://www.google.com/search?q=#{URI.encode(parsed[:message])}")
    end
  else
    send_to_channel("Uhm, you should start your question with 'Hey Siri', you know... otherwise I don't have to respond.")
    @hey_siri_response_given = true
  end
end

require_relative './irc_magic.rb'
