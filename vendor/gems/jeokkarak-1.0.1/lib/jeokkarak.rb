module Jeokkarak
  module Base
    
    # defines that this type has a child element
    def has_child(type, options={})
      resource_children[options[:as]] = type
    end
    
    # checks what is the type element for this type (supports rails ActiveRecord, has_child and Hashi)
    def child_type_for(name)
      return reflect_on_association(key.to_sym ).klass if respond_to? :reflect_on_association
      resource_children[name] || Hashi
    end
    
    # returns the registered children list for this resource
    def resource_children
      @children ||= {}
      @children
    end
    
    # creates an instance of this type based on this hash
    def from_hash(h)
      h = h.dup
      result = self.new
      result._internal_hash = h
      h.each do |key,value|
        from_hash_parse result, h, key, value
      end
      def result.method_missing(name, *args, &block)
          Hashi.to_object(@_internal_hash).send(name, args[0], block)
      end
      result
    end
    
    # extension point to parse a value
    def from_hash_parse(result,h,key,value)
      case value.class.to_s
      when 'Array'
        h[key].map! { |e| child_type_for(key).from_hash e }
      when /\AHash(WithIndifferentAccess)?\Z/
        h[key] = child_type_for(key ).from_hash value
      end
      name = "#{key}="
      result.send(name, value) if result.respond_to?(name)
    end
  end
end

module Jeokkarak
  module Config
    
    # entry point to define a jeokkarak type
    def acts_as_jeokkarak
      self.module_eval do
        attr_accessor :_internal_hash
      end
      self.extend Jeokkarak::Base
    end
  end
end

Object.extend Jeokkarak::Config