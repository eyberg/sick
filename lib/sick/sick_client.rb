#!/usr/bin/ruby
require 'socket'
require 'yaml'

class SIck
  attr_accessor :clientSession

  def initialize(ip, port)
    self.clientSession = TCPSocket.new(ip, port)
  end

  def send(msg)
    self.clientSession.puts "#{msg}\n"

    data = self.clientSession.gets("\377")

    msg = YAML::load(data[0..data.size - 2])

    if msg.class.eql? String then 
      if msg.include?("No")
        close
      end
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
