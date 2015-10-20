require 'spec_helper'

describe Taxii::Messages::DiscoveryRequest do
  let(:spec_parser) { Nori.new }
  context 'initializing instances' do
    it 'instantiates without a message_id argument' do
      dr = Taxii::Messages::DiscoveryRequest.new
      expect(dr).to be_a(Taxii::Messages::DiscoveryRequest)
    end
    it 'instantiates with a message_id argument' do
      dr = Taxii::Messages::DiscoveryRequest.new(message_id: '1010101')
      expect(dr).to be_a(Taxii::Messages::DiscoveryRequest)
    end
  end
  context 'rendering xml' do
    let(:dr) { Taxii::Messages::DiscoveryRequest.new(message_id: 100)}
    let(:dr_xml) { dr.to_xml }
    describe '#to_xml' do
      it 'generates a self-closing message' do
        expect(dr_xml).to match(%r{<taxii_11:Discovery_Request .*/>})
      end
      it 'embeds the message_id' do
        expect(dr_xml).to match(%r{message_id="100"})
      end
      it 'adds all the namespace qualifiers' do
        parsed=spec_parser.parse(dr_xml)['taxii_11:Discovery_Request']
        expect(parsed.keys).to include( "@xmlns:taxii", "@xmlns:taxii_11", "@xmlns:tdq")
      end
    end
  end
end
