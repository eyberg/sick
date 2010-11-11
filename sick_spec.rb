require 'sick_client.rb'
require 'sick_server.rb'

Thread.start do
  sick_server = SIckServer.new('127.0.0.1', '313378')
end

describe SIck, "API" do
  
  before(:all) do
    @sick = SIck.new('127.0.0.1', '313378')
  end

  it "should be able to create a bucket" do
    retval = @sick.create_bucket("my_bucket")

    retval.should == "created bucket\n"
  end

  it "should be able to put a key in" do
    retval = @sick.put("my_bucket", "mykey", "myvalue")

    retval.should == "put received\n"
  end

  it "should be able to get the value of a key" do
    retval = @sick.get("my_bucket", "mykey")

    retval.should == "myvalue\n"
  end

  it "should create destroy a bucket" do
    retval = @sick.destroy_bucket("my_bucket")

    retval.should == "destroyed bucket\n"
  end

end
