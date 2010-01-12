require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Client::Instance do
  
  context "when parsing a transition execution" do
    
    before do
      @o = Object.new
      @o.extend Restfulie::Client::Instance
    end
    
    #test method parsing
    #test with request body
    # test with block
    
    it "should return the parsed response" do
      args = Object.new
      name = "pay"
      @o.should_receive(:parse_args_from_transition).with(args).and_return([nil, {}])
      Restfulie::Client::Config.should_receive(:requisition_method_for).with(nil, name).and_return()
    end

    it "should leave data as nil and options as hash if there is no arg" do
      data, options = @o.parse_args_from_transition([])
      data.should be_nil
      options.should be_empty
    end

    it "should leave data as it was and options as new hash if there is an option" do
      data, options = @o.parse_args_from_transition([123])
      data.should eql(123)
      options.should be_empty
    end

    it "should leave data as it was options as its hash if there are both args" do
      hash = { :name => :value }
      data, options = @o.parse_args_from_transition([123, hash])
      data.should eql(123)
      options.should eql(hash)
    end

    it "should create data as nil and options as it was if there is only a hash" do
      hash = { :name => :value }
      data, options = @o.parse_args_from_transition([hash])
      data.should be_nil
      options.should eql(hash)
    end

    it "should invoke add header for every header" do
      req = Object.new
      req.should_receive(:add_field).with(:extra, :value)
      @o.add_headers req, :headers => {:extra => :value}
    end

  end

end
