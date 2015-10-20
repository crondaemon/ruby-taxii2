require 'spec_helper'

describe Taxii::Messages::FeedInformationRequest do
  let(:spec_parser) { Nori.new }
  context 'initializing instances' do
    it 'instantiates without a message_id argument' do
      fir = Taxii::Messages::FeedInformationRequest.new
      expect(fir).to be_a(Taxii::Messages::FeedInformationRequest)
    end
    it 'instantiates with a message_id argument' do
      fir = Taxii::Messages::FeedInformationRequest.new(message_id: '1010101')
      expect(fir).to be_a(Taxii::Messages::FeedInformationRequest)
    end
  end
  context 'rendering xml' do
    let(:fir) { Taxii::Messages::FeedInformationRequest.new(message_id: 100)}
    let(:fir_xml) { fir.to_xml }
    describe '#to_xml' do
      it 'generates a self-closing message' do
        expect(fir_xml).to match(%r{<taxii:Feed_Information_Request .*/>})
      end
      it 'embeds the message_id' do
        expect(fir_xml).to match(%r{message_id="100"})
      end
      it 'adds all the namespace qualifiers' do
        parsed=spec_parser.parse(fir_xml)['taxii:Feed_Information_Request']
        expect(parsed.keys).to include( "@xmlns:taxii", "@xmlns:taxii_11", "@xmlns:tdq")
      end
    end
  end
end
