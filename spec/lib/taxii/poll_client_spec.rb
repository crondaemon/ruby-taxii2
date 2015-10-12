require 'spec_helper'

describe Taxii::PollClient do
  context 'initializing instances'
  context 'generating requests' do

    let(:discovery_req) { '<taxii_11:Discovery_Request     xmlns:taxii="http://taxii.mitre.org/messages/taxii_xml_binding-1" xmlns:taxii_11="http://taxii.mitre.org/messages/taxii_xml_binding-1.1" xmlns:tdq="http://taxii.mitre.org/query/taxii_default_query-1" message_id="100"/>' }
    let(:feed_info)     { '<taxii:Feed_Information_Request xmlns:taxii="http://taxii.mitre.org/messages/taxii_xml_binding-1" xmlns:taxii_11="http://taxii.mitre.org/messages/taxii_xml_binding-1.1" xmlns:tdq="http://taxii.mitre.org/query/taxii_default_query-1" message_id="100"/>'}
    it 'generates a valid discovery request' do

    end
  end

  context 'discovering feeds' do


    it 'verifies the POLL service is available'
  end
end
