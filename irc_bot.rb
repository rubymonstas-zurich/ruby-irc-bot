require 'socket'

class IrcBot
  attr_accessor :name
  attr_reader :socket, :server, :port, :channel

  def initialize(server, port, channel)
    @server = server
    @port = port
    @channel = channel
  end

  def run
    connect

    until socket.eof? do
      message = socket.gets
      puts message

      if message.start_with? "PING"
        handle_ping_message(message)
      elsif message.include? "PRIVMSG #{channel}"
        handle_channel_message(message)
      end
    end
  end

  def connect
    @socket = TCPSocket.open(server, port)
    irc_send "NICK #{name}"
    irc_send "USER #{name} 0 * :#{name}"
    irc_send "JOIN #{channel}"
  end

  def irc_send(message)
    puts "Sending: #{message}"
    socket.puts message
  end

  def handle_ping_message(message)
    hostname = message.split(' ').last
    irc_send "PONG #{hostname}"
  end

  def handle_channel_message(message)

  end
end

bot = IrcBot.new("irc.freenode.net", 6667, "#rubymonstas")
bot.name = "nerdinand-bot"
bot.run
