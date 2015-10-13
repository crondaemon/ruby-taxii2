module Taxii
  module Messages
    TAXII_11_HEADERS = {
      'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.1',
      'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.1'
    }

    TAXII_10_HEADERS = {
      'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.0',
      'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.0'
    }

    NAMESPACE_ATTRIBUTES = {
      '@xmlns:taxii'    => 'http://taxii.mitre.org/messages/taxii_xml_binding-1',
      '@xmlns:taxii_11' => 'http://taxii.mitre.org/messages/taxii_xml_binding-1.1',
      '@xmlns:tdq'      => 'http://taxii.mitre.org/query/taxii_default_query-1'
    }

    TS_FORMAT='%Y-%m-%dT%H:%M:%S%:z'

    def self.generate_id
      format('%012d%08d',Time.new.to_i,$$)
    end
  end
end
