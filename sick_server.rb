#!/usr/bin/ruby
require 'socket'

class SIckServer
  attr_accessor :buckets
  attr_accessor :logging

  def initialize(ip, port, logging=:off)
    self.buckets = {}
    self.logging = logging

    log("Starting up server...")

    server = TCPServer.new(port)

    # main event loop
    while (session = server.accept)

      Thread.start do
        socket = "#{session.peeraddr[2]}:#{session.peeraddr[3]}"

        log("log: Connection from #{socket}")

        begin
          handle_input(session.gets, session)
        end while 1 == 1

      end

    end
  end

  # log the message
  def log(msg)
    if !self.logging.eql? :off then
      puts msg
    end
  end

  # loads all the buckets into memory
  def restore_from_disk

    entries = Dir.entries("buckets").collect do |f| f unless f.match("bucket").nil? end.compact

    entries.each do |e|
      File.open(e, 'r') do |f|
        @contents = f.read
      end

      buckets["#{e.gsub(".bucket", "")}"] = @contents
    end

  end

  # save to disk
  def persist(bucket)

    Thread.new do

      puts "creating buckets dir"
      Dir.mkdir('buckets') unless File.directory?('buckets')

      puts "filing file"
      # take hash of bucket
      File.open('buckets/' + bucket + ".bucket", 'w') do |f|
        f.write(buckets["#{bucket}"])
      end

    end

  end

  # handle incoming input
  def handle_input(input, session)
    get_reg = /get bucket: (.*), key: (.*)\n/
    put_reg = /put bucket: (.*), key: (.*), value: (.*)\n/
    create_reg = /create bucket: (.*)/
    destroy_reg = /destroy bucket: (.*)/

    log("got the following from the client: #{input}")

    case input
    when get_reg
      matches = input.match(get_reg)
      bucket = matches[1]
      key = matches[2]

      value = buckets["#{bucket}"]["#{key}"]
      session.puts "#{value}\n"

    when put_reg
      matches = input.match(put_reg)
      bucket = matches[1]
      key = matches[2]
      value = matches[3]

      buckets["#{bucket}"]["#{key}"] = "#{value}"
      persist(bucket)

      session.puts "put received\n"

    when create_reg
      matches = input.match(create_reg)
      bucket = matches[1]
      buckets["#{bucket}"] = {}
      session.puts "created bucket\n"

    when destroy_reg
      matches = input.match(destroy_reg)
      bucket = matches[1]
      buckets.delete("#{bucket}")
      session.puts "destroyed bucket\n"

    else
      session.puts "No\n"
    end
  end

end
