require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientsController
  include Restfulie::Server::Controller
  
end
class Client
end

context Restfulie::Server::Controller do
  
  before do
    @controller = ClientsController.new
  end

  context "while preparing the request info" do
    
    it "should extract the model part from the Controller name" do
      @controller.model_for_this_controller.should eql(Client)
    end
    
    it "should not fit content if it is not registered" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(false)
      @controller.fits_content(Client, 'vnd/my_custom+xml').should be_false
    end
    
    it "should not fit content if is registered for another type" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(true)
      Restfulie::MediaType.should_receive(:media_type).with('vnd/my_custom+xml').and_return(String)
      @controller.fits_content(Client, 'vnd/my_custom+xml').should be_false
    end
    
  end
  
  context "when creating a resource" do
    
    before do
      @req = Hashi::CustomHash.new
      @req.headers = {'CONTENT_TYPE' => 'vnd/my_custom+xml'}
      @controller.should_receive(:request).at_least(1).and_return(@req)
      @result = "final result"
    end

    it "should return 415 if the media type is not supported" do
      @controller.should_receive(:fits_content).with(Client, 'vnd/my_custom+xml').and_return(false)
      @controller.should_receive(:head).with(415).and_return(@result)
      @controller.create.should eql(@result)
    end

    it "should save models if everything goes fine" do
      model = Hashi::CustomHash.new
      model.save = true
      @controller.should_receive(:fits_content).with(Client, 'vnd/my_custom+xml').and_return(true)
      Restfulie.should_receive(:from).with(@req).and_return(model)
      @controller.should_receive(:render_created).with(model).and_return(@result)
      @controller.create.should eql(@result)
    end

    it "render the errors if something goes wrong" do
      model = Hashi::CustomHash.new
      model.errors = Object.new
      model.save = false
      @controller.should_receive(:fits_content).with(Client, 'vnd/my_custom+xml').and_return(true)
      Restfulie.should_receive(:from).with(@req).and_return(model)
      @controller.should_receive(:render).with({:xml => model.errors, :status => :unprocessable_entity}).and_return(@result)
      @controller.create.should eql(@result)
    end

  end

end