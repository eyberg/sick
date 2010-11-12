Thread.start do
  sick_server = SIckServer.new('127.0.0.1', '313378')
end

describe SIck, "API" do
  
  before(:all) do
    @sick = SIck.new('127.0.0.1', '313378')
  end

  it "should be able to create a bucket" do
    retval = @sick.create_bucket("my_bucket")

    retval.should == "created bucket"
  end

  it "should be able to put a key in" do
    retval = @sick.put("my_bucket", "mykey", "myvalue")

    retval.should == "put received"
  end

  it "should be able to get the value of a key" do
    retval = @sick.get("my_bucket", "mykey")

    retval.should == "myvalue"
  end

  it "should create destroy a bucket" do
    retval = @sick.destroy_bucket("my_bucket")

    retval.should == "destroyed bucket"
  end

  it "should have random results" do
    @sick.create_bucket("random_test")

    100.times do |i|
      @sick.put("random_test", "key" + i.to_s, "val" + (i*3).to_s)
    end

    result_set1 = @sick.random_from("random_test", 20)

    result_set2 = @sick.random_from("random_test", 10)

    result_set1.size.should == 20
    result_set2.size.should == 10

    result_set1.should_not == result_set2

  end

  it "should kill the server to see if the data has been persisted"

end
