# customize the name of your bot on the following line
@name = "nerdinand-bot"

# This method gets called, whenever a message is sent to our IRC channel. In it you can react to
# the users' inputs in whatever way you like...
def handle_privmsg(sender, recipient, chat_message)
  # In here you can react to messages that appear in the channel or are sent to your bot privately.
  
  # You get these 3 pieces of information:
  # * sender:       This is the user name that sent the message to your bot.
  # * recipient:    This is who the message was sent to. It can either be the name of a channel 
  #                 that your bot has joined (e.g. "#rubymonstas"), or it is the name of your bot,
  #                 in which case this is a private message sent directly to your bot.
  # * chat_message: This is the content of the message that the user has typed.

  # Here you can write code that handles this information to interact with the users.
  # You can let the bot send messages by calling the `send_privmsg` method, for example like this:
  # send_privmsg("#rubymonstas",  "Hi everyone!")
end

require_relative './irc_magic.rb'
