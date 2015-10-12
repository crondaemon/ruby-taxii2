module Taxii
  module Message
    TAXII_11_MESSAGE = {
      'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.1',
      'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.1'
    }

    TAXII_10_MESSAGE = {
      'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.0',
      'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.0'
    }

    NAMESPACES = {
      'xmlns:taxii'    => 'http://taxii.mitre.org/messages/taxii_xml_binding-1',
      'xmlns:taxii_11' => 'http://taxii.mitre.org/messages/taxii_xml_binding-1.1',
      'xmlns:tdq'      => 'http://taxii.mitre.org/query/taxii_default_query-1'
    }

    def message_id(sequence_start = 1000)
      @mid_seq ||= sequence_start
      @mid_seq += 1
    end

    def discovery_request_message
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii_11'].Discovery_Request(
          NAMESPACES.merge({'message_id': message_id})
        )
      end
      build.doc.to_s
    end

    def feed_information_request_message
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii'].Feed_Information_Request(
          NAMESPACES.merge({'message_id': message_id} )
        )
      end
      build.doc.to_s
    end 
  end
end