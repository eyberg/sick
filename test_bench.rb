require 'rubygems'
require 'sick'

require 'benchmark'

puts "priming the pump"


sick = SIck.new('127.0.0.1', '31337')

sick.create_bucket("shit")

# bucket == category_customer_id
# we group our adv-srcs into buckets
# so there's like 5k in each bucket maybe

bucket = "475_1"

puts "this will take a while -- but these are inserts..."

stuff = ''
5000.times do |i|
  sick.put("shit", i, "value" + i.to_s )
end

puts "actual selects"

puts Benchmark.measure { 20.times do |i| sick.random_from("shit", 5) end }
