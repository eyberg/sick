#!/usr/bin/ruby
require 'socket'

class SIckServer
  attr_accessor :buckets
  attr_accessor :logging

  def initialize(ip, port, logging=:off)
    self.buckets = {}
    self.logging = logging

    restore_from_disk

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
    log("Loading Data in...")

    if File.directory?('buckets') then
      entries = Dir.entries("buckets").collect do |f| f unless f.match("bucket").nil? end.compact

      entries.each do |e|
        File.open("buckets/" + e) do |f|
          @contents = Marshal.load(f)
        end

        buckets["#{e.gsub(".bucket", "")}"] = @contents

      end

    end

  end

  # grab num random results from bucket
  def random_from(bucket, num)
    #ret = {}

    rbucket = buckets["#{bucket}"]

    puts 'pst adsf'

    begin

      ret = rbucket.sort_by{ rand }.slice(0..num).collect { |k,v| { k => v } }

      #num.to_i.times do |i|
      #  ret[i] = rbucket[rand(rbucket.size)]
      #end

    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      puts "fucking cok ae assoo!!"
    end

    puts 'zxcv'
    return ret
  end

  # save to disk
  def persist(bucket)

    Thread.new do

      puts "creating buckets dir"
      Dir.mkdir('buckets') unless File.directory?('buckets')

      puts "filing file"
      # take hash of bucket
      File.open('buckets/' + bucket + ".bucket", 'w') do |f|
        Marshal.dump(buckets["#{bucket}"], f)
      end

    end

  end

  # handle incoming input
  def handle_input(input, session)
    get_reg = /get bucket: (.*), key: (.*)\n/
    put_reg = /put bucket: (.*), key: (.*), value: (.*)\n/
    create_reg = /create bucket: (.*)/
    destroy_reg = /destroy bucket: (.*)/
    rand_reg = /rand bucket: (.*) count: (.*)/

    log("got the following from the client: #{input}")

    case input
    when rand_reg
      matches = input.match(rand_reg)
      bucket = matches[1]
      count = matches[2]

      begin
        puts 'got here'

        ret = random_from(bucket, count.to_i)

        puts 'zxcvzxcv'
        session.puts "#{ret}\n"
      rescue
        puts e.message
        puts e.backtrace.inspect
  
        session.puts "FUCK\n"
      end

    when get_reg
      matches = input.match(get_reg)
      bucket = matches[1]
      key = matches[2]

      begin
        value = buckets["#{bucket}"]["#{key}"]
        session.puts "#{value}\n"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect

        session.puts "FUCK\n"
      end

    when put_reg
      matches = input.match(put_reg)
      bucket = matches[1]
      key = matches[2]
      value = matches[3]

      begin
        buckets["#{bucket}"]["#{key}"] = "#{value}"
        persist(bucket)

        session.puts "put received\n"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect

        session.puts "FUCK\n"
      end


    when create_reg
      matches = input.match(create_reg)
      bucket = matches[1]

      begin
        buckets["#{bucket}"] = {}
        session.puts "created bucket\n"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect

        session.puts "FUCK\n"
      end

    when destroy_reg
      matches = input.match(destroy_reg)
      bucket = matches[1]

      begin
        buckets.delete("#{bucket}")
        session.puts "destroyed bucket\n"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect

        session.puts "FUCK\n"
      end

    else
      session.puts "No\n"
    end
  end

end
