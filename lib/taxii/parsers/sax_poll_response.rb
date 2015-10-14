# STILL DOOMED TO FAILURE. I WILL KEEP THIS AS A WARNING TO
# SIMILARLY TERRIBLE CODE 
module Taxii
  module MessageParsers
    class PollResponse < Nokogiri::XML::SAX::Document
      def package_data
        @package_data ||= []
      end
      def capture
        @capture.nil? ? @capture = false : @capture
      end
      def capture=(flag)
        @capture=flag
      end
      def start_element(name, attrs=[])
        if name.match(/taxii_11:Content_Block/)
          STDERR.puts 'START Content_Block'
          self.capture=true
        end
      end
      def characters(str)
        self.package_data << str
      end
      def end_element(name, attrs=[])
        if name.match(/taxii_11:Content_Block/)
          STDERR.puts 'END Content_Block'
          self.capture=false
        end
      end
    end
  end
end
