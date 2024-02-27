#############################################
# Standard IRC bot stuff, don't change this #
#############################################

# We tell Ruby we want to use the 'socket' part of the
# standard library in this file
require "socket"

# We declare an instance variable called "joined" with the value false
@joined = false

# A method that lets us connect to a server
def connect
  # We open a new socket connection to the server @server on port @port
  @socket = TCPSocket.open(@server, @port)

  # We send an IRC message that's sets the bot's nickname to @name
  irc_send("NICK #{@name}")

  # We send an IRC message that's sets users usename and real name to @name
  irc_send("USER #{@name} 0 * :#{@name}")
end

# A method that sends a command to join an IRC channel.
# It takes the channel as a method argument. The channel name must begin with a "#"
def irc_send_join(channel)
  # We send an IRC message that joins a channel
  irc_send("JOIN #{channel}")
end

# A method that sends an IRC-protocol message to the server and also puts it to the terminal
def irc_send(message)
  # To be able to see what things we are sending to the server, we are also outputting it to the command line
  puts("Sending: #{message}")

  # We can call "puts" on the socket we opened earlier. Instead of outputting something on the
  # terminal, this will send the message accross the internet to the IRC server we are connected to
  @socket.puts(message)
end

# A method that sends a PRIVMSG message to a recipient (either a channel or a user).
def send_privmsg(recipient, message)
  # We put together an IRC protocol message that the server will be able to interpret and hand it to the irc_send method, which sends it to the IRC server.
  irc_send("PRIVMSG #{recipient} :#{message}")
end

# The server will regularly ask if our bot is still around using "PING" messages. This method allows
# us to respond to the PINGs with a PONG, so our connection does not get closed accidentally.
def handle_ping_message(message)
  # The last part of the PING message is the so-called "challenge". The server expects that we reply
  # back with this exact string. Therefore we extract it here.
  challenge = message.split(" ").last

  # We send back an IRC "PONG" message with the challenge that came from the server.
  irc_send "PONG #{challenge}"
end

# The main method of our bot. It connects to the server and then keeps the connection
# open in a loop and reacts to different kinds of incoming messages.
def run
  # First thing to do is to connect to the server
  connect

  # Here we keep the connection open, as long as it's not getting closed by the server (that would result in
  # @socket.eof? returning true).
  until @socket.eof? do

    # We read the next incoming message from the socket connection.
    message = @socket.gets

    # We ouput the message on the terminal, so we can see what our bot's input is.
    puts message

    # If the message we are getting is a "PING" message...
    if message.start_with?("PING")
      # ...then we need to react to that PING, so as to not get disconnected accidentally.
      handle_ping_message(message)

    # If the message is a private message sent inside our channel...
    elsif message.include?("PRIVMSG")
      # message is of the form ":nerdinand!~nerdinand@178.197.219.93 PRIVMSG #rubymonstas :hi"

      # We can get the actual chat message out of this message string by splitting it apart at the `:`, this returns an array that looks like this: ["", "nerdinand!~nerdinand@178.197.219.93 PRIVMSG #rubymonstas ", "hi"]
      message_parts = message.split(":")

      # We take the 3rd up until the last element of this array (-1 means the last element in the array) we join these elements back together into the chat_message.
      # The joining part is done just in case the user has used a ":" in their message.
      chat_message = message_parts[2..-1].join(':')

      # We can split the original message again, this time by spaces. The first element of that resulting array looks like this: ":nerdinand!~nerdinand@178.197.219.93"
      sender_identifier = message.split(' ').first
      
      # Then we can split that again by "!" and take the first element minus the first character, which looks like this: "nerdinand"
      sender = sender_identifier.split('!').first[1..-1]

      # Extracting the recipient out of the message is easy: We can split by spaces again and take the third element, this results in: '#rubymonstas'
      recipient = message.split(' ')[2]

      # Having collected all of that information, we can now call the handle_privmsg method which is the "meat" of our bot. 
      # This is the method you can implement in `irc_bot.rb`!
      handle_privmsg(sender, recipient, chat_message)

    # If we haven't joined our channel yet and the message includes "MODE" and the bot's name...
    elsif !@joined && message.include?("MODE #{@name}")
      # ...then the server is ready for us to join the channel.
      irc_send_join(@channel)
      # We set @joined to true, so we don't try to join the channel twice accidentally.
      @joined = true
    end
  end
end

# The host name of the IRC server we want to connect to
@server = "irc.libera.chat"

# The port on the server we want to connect to with our bot
@port = 6667

# The name of our channel we want to join on the IRC server
@channel = "#rubymonstas"

run
