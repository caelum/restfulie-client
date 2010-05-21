require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

class ProjectsController < ApplicationController
  self.responder = Restfulie::Server::ActionController::RestfulResponder

  def index; end
  def show; end
  def new; end
end

ActionController::Routing::Routes.draw do |map|
  map.connect ":controller/:action/:id"
end

describe ProjectsController, :type => :controller do
  tests ProjectsController
  integrate_views

  it "renders view files with tokamak extension" do
    request.accept = "application/atom+xml"
    get :index, :format => :atom
    response.body.should include("<title>index.atom.tokamak</title>")
  end

  it "renders view files without explicit format" do
    request.accept = "application/atom+xml"
    get :show, :format => :atom
    response.body.should include("<title>show.tokamak</title>")
  end
  
  it "prefers views with explicit format" do
    request.accept = "application/atom+xml"
    get :new, :format => :atom
    response.body.should include("<title>new.atom.tokamak</title>")
  end
end