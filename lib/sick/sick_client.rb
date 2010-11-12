#!/usr/bin/ruby
require 'socket'

class SIck
  attr_accessor :clientSession

  def initialize(ip, port)
    self.clientSession = TCPSocket.new(ip, port)
  end

  def send(msg)
    self.clientSession.puts "#{msg}\n"

    msg = self.clientSession.gets
 
    if msg.include?("No")
      close
    end

    return msg
  end

  # get a key from a bucket
  def get(bucket, key)
    send("get bucket: #{bucket}, key: #{key}")
  end

  # put a key into a bucket
  def put(bucket, key, value)
    send("put bucket: #{bucket}, key: #{key}, value: #{value}")
  end

  # create a bucket
  def create_bucket(name)
    send("create bucket: #{name}")
  end

  # destroy a bucket
  def destroy_bucket(name)
    send("destroy bucket: #{name}")
  end

  # retrieve count random elements from bucket
  def random_from(bucket, count)
    send("rand bucket: #{bucket} count: #{count}")
  end

  # get a ref to a bucket
  def get_bucket(bucket)
  end

  # close the connection
  def close
    self.clientSession.close
  end

end
