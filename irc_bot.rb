# customize the name of your bot on the following line
@name = "your-name-bot"

# This method gets called, whenever a message is sent to our IRC channel. In it you can react to
# the users' inputs in whatever way you like...
def handle_channel_message(message)
  # Implement your ideas here. 
  # The string in `message` will look something like this: 
  # ":nerdinand!b2c5e1f5@gateway/web/freenode/ip.178.197.225.245 PRIVMSG #rubymonstas :Look at me, I'm here!"
  # 
  # You can use the method `irc_send` to send strings to the IRC server, e.g.
  # irc_send("PRIVMSG #rubymonstas :Hi everyone!")
end

require_relative './irc_magic.rb'
