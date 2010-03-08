require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CustomType < ActiveRecord::Base
  acts_as_restfulie
end

context Restfulie::Server::Base do
  
  context "when creating a transition" do
    class Account
      acts_as_restfulie
    end
    class AccountsController
    end
    it "should not add a pay method if it doesnt exist" do
      Account.transition :pay
      AccountsController.should_not respond_to(:pay)
    end
  end  
end