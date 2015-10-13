# DOOMED TO FAILURE XPATH EASIER
module Taxii
  module Messages
    class PollResponse < Nokogiri::XML::SAX::Document
    attr_reader :taxii_content
    attr_accessor :capture
    def initialize
      @capture = false
      @taxii_content = []
    end
    def start_element(name,*attrs)
      if name=='taxii_11:Content'
        puts 'capturing'
        self.capture=true
      end
    end
    def characters(str)
      taxii_content.push(str) if capture
    end
    def end_element(name,*attrs)
      if name=='taxii_11:Content'
        puts 'stop capturing'
        self.capture=false 
      end
    end
  end
end