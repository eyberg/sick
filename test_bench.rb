require 'rubygems'
require 'sick'

sick = SIck.new('127.0.0.1', '31337')

sick.create_bucket("shit")

# bucket == category_customer_id
# we group our adv-srcs into buckets
# so there's like 5k in each bucket maybe

bucket = "475_1"

stuff = ''
5000.times do |i|
  sick.put("shit", i, "value" + i.to_s )
end
