require 'spec_helper'
describe Taxii::Message do
  let(:fake_client_cls) { 
    class FakeClient
      include Taxii::Message
    end
  }
  
  let(:fake_client) { fake_client_cls.new }

  let(:spec_parser) { Nori.new }

  context 'generating message ids' do
    describe '#message_id' do
      it 'initializes with a sequence number' do
        id = fake_client.message_id(100)
        expect(id).to eq(101)
      end
    end
  end

  context 'generating messages' do
    describe 'feed_information_request_message' do
      let(:request_message) { fake_client.feed_information_request_message }

      it 'generates a taxii:Feed_Information_Request document' do
        expect(request_message).to match(%r{<taxii:Feed_Information_Request})
      end

      it 'includes the message namespaces' do
        Taxii::Message::NAMESPACES.each do |ns,url|
          expect(request_message).to match(%r{#{ns}="#{url}"})
        end
      end

      it 'includes a message_id' do
        expect(request_message).to match(%r{message_id="[0-9]+"})
      end

      it 'is parseable xml' do
        parsed = spec_parser.parse(request_message)
        expect(parsed.keys).to eq(['taxii:Feed_Information_Request'])
      end
    end

    describe 'discovery_request_message' do
      let(:request_message) { fake_client.discovery_request_message }

      it 'generates a taxii_11:Discovery_Request document' do
        expect(request_message).to match(%r{<taxii_11:Discovery_Request})
      end

      it 'includes the message namespaces' do
        Taxii::Message::NAMESPACES.each do |ns,url|
          expect(request_message).to match(%r{#{ns}="#{url}"})
        end
      end

      it 'includes a message_id' do
        expect(request_message).to match(%r{message_id="[0-9]+"})
      end

      it 'is parseable xml' do
        parsed = spec_parser.parse(request_message)
        expect(parsed.keys).to eq(['taxii_11:Discovery_Request'])
      end
    end
  end
end