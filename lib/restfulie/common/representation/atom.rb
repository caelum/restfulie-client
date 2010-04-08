module Restfulie::Common::Representation
  # Implements the interface for unmarshal Atom media type responses (application/atom+xml) to ruby objects instantiated by rAtom library.
  #
  # Furthermore, this class extends rAtom behavior to enable client users to easily access link relationships.
  class Atom

    cattr_reader :media_type_name
    @@media_type_name = 'application/atom+xml'

    cattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { 'Content-Type' => media_type_name }
    }

    #Convert raw string to rAtom instances (client side)
    def unmarshal(content)
      ::Atom::Feed.load_feed(content)
    end

    def marshal(string, rel)
      string
    end

    # transforms this content into a parameter hash for rails (server-side usage)
    def self.to_hash(content)
      Hash.from_xml(content).with_indifferent_access
    end
    
    def prepare_link_for(link)
      link
    end
    
    def prepare_link_for(link)
      link
    end
  end

end

