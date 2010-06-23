require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP::RequestBuilder do
  context "chaining requests" do
    it "should accept parameters in get requests" do
      @result = Restfulie::Client::EntryPoint.at('http://localhost:4567/request_with_querystring').get!(:foo => "bar", :bar => "foo")
      params  = JSON.parse(@result)
      params["foo"].should == "bar"
      params["bar"].should == "foo"
    end
  end
end