require 'restfulie/common'
require 'restfulie/client'

# Shortcut to RestfulieDsl
module Restfulie

  # creates a new entry point for executing requests
  def self.at(uri)
    Restfulie.use.at(uri)
  end

  def self.using(&block)
    RestfulieUsing.new.instance_eval(&block)
  end
  
  def self.use(&block)
    if block_given?
      Restfulie::Client::Dsl.new.instance_eval(&block)
    else
      Restfulie::Client::Dsl.new
    end
  end
  
end

class RestfulieUsing
  def method_missing(sym, *args)
    @current = "Restfulie::Client::HTTP::#{sym.to_s.classify}".constantize.new(@current || Restfulie::Client::HTTP::RequestAdapter.new, *args)
  end
end
