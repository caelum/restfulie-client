module Restfulie::Client#:nodoc

  module EntryPoint
    include HTTP::RequestMarshaller
    extend self

    @resources_configurations = {}
    def configuration_of(resource_name)
      @resources_configurations[resource_name]
    end

    def configuration_for(resource_name,configuration = Configuration.new)
      yield configuration if block_given?
      @resources_configurations[resource_name] = configuration
    end

    def retrieve(resource_name)
      returning Object.new do |resource| 
        restore.extend(Base)
        resource.configure
      end
    end

  end
  class NilEntryPoint
    include Restfulie::Client::EntryPoint
    # extend self
  end

  module Base
    include HTTP::RequestMarshaller
   
    def self.included(base)#:nodoc
      base.extend(self)
    end

    def uses_restfulie(configuration = Configuration.new,&block)
      EntryPoint.configuration_for(resource_name,configuration,&block)
      configure
    end

    def configure
      configuration = EntryPoint.configuration_of(resource_name)
      raise "Undefined configuration for #{resource_name}" unless configuration
      at(configuration.entry_point)
      configuration.representations.each do |representation_name,representation|
        register_representation(representation_name,representation)
      end
    end

    def resource_name
      @resource_name || @resource_name = self.class.to_s.to_sym 
    end

  end

end


# Shortcut to Restfulie::Client::EntryPoint
module Restfulie
  def self.at(uri)
    Client::NilEntryPoint.new.at(uri)
  end
end

