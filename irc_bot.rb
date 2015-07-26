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
  puts("Sending: #{message}")

  # We can call "puts" on the socket we opened earlier. Instead of outputting something on the
  # terminal, this will send the message accross the internet to the IRC server we are connected to
  @socket.puts(message)
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
    elsif message.include?("PRIVMSG #{@channel}")
      # ...then we react in some way to that message.
      handle_channel_message(message)

    # If we haven't joined our channel yet and the message includes "MODE" and the bot's name...
    elsif !@joined && message.include?("MODE #{@name}")
      # ...then the server is ready for us to join the channel.
      irc_send_join(@channel)
      # We set @joined to true, so we don't try to join the channel twice accidentally.
      @joined = true
    end
  end
end

###############################################
# Implement your own ideas below this comment #
###############################################

# This method gets called, whenever a message is sent to our IRC channel. In it you can react to
# the users' inputs in whatever way you like...
def handle_channel_message(message)

end

# The host name of the IRC server we want to connect to
@server = "irc.freenode.net"

# The port on the server we want to connect to with our bot
@port = 6667

# The name of your bot. Choose something that ends in -bot, so we know it's a bot ;)
@name = "nerdinand-bot"

# The name of our channel we want to join on the IRC server
@channel = "#rubymonstas"

# After setting all the variables and defining the necessary methods, we can call the "run" method,
# which will start our bot and make the magic happen!
run
