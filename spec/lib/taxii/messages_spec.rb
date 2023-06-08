require 'spec_helper'
describe Taxii::Messages do

  let(:spec_parser) { Nori.new }

  # context 'generating message ids' do
  #   describe '.generate_id' do
  #     it 'returns an id'
  #   end
  # end
  # 
  # context 'generating messages' do
  #   describe 'feed_information_request_message' do
  #     let(:request_message) { fake_client.feed_information_request_message }
  #
  #     it 'generates a taxii:Feed_Information_Request document' do
  #       expect(request_message).to match(%r{<taxii:Feed_Information_Request})
  #     end
  #
  #     it 'includes the message namespaces' do
  #       Taxii::Message::NAMESPACES.each do |ns,url|
  #         expect(request_message).to match(%r{#{ns}="#{url}"})
  #       end
  #     end
  #
  #     it 'includes a message_id' do
  #       expect(request_message).to match(%r{message_id="[0-9]+"})
  #     end
  #
  #     it 'is parseable xml' do
  #       parsed = spec_parser.parse(request_message)
  #       expect(parsed.keys).to eq(['taxii:Feed_Information_Request'])
  #     end
  #   end
  #
  #   describe 'discovery_request_message' do
  #     let(:request_message) { fake_client.discovery_request_message }
  #
  #     it 'generates a taxii_11:Discovery_Request document' do
  #       expect(request_message).to match(%r{<taxii_11:Discovery_Request})
  #     end
  #
  #     it 'includes the message namespaces' do
  #       Taxii::Message::NAMESPACES.each do |ns,url|
  #         expect(request_message).to match(%r{#{ns}="#{url}"})
  #       end
  #     end
  #
  #     it 'includes a message_id' do
  #       expect(request_message).to match(%r{message_id="[0-9]+"})
  #     end
  #
  #     it 'is parseable xml' do
  #       parsed = spec_parser.parse(request_message)
  #       expect(parsed.keys).to eq(['taxii_11:Discovery_Request'])
  #     end
  #   end
  # end

  context 'content block' do
    let(:content_block){ Taxii::Messages::ContentBlock.new(File.read('spec/fixtures/content_block.xml')) }
    let(:exclusive_begin_timestamp) do
      Taxii::Messages::ExclusiveBeginTimestamp.new(File.read('spec/fixtures/exclusive_begin_timestamp.xml'))
    end
    let(:inclusive_end_timestamp) do
      Taxii::Messages::InclusiveEndTimestamp.new(File.read('spec/fixtures/inclusive_end_timestamp.xml'))
    end

    describe 'give utilities to the user' do
      it 'gives the user a string' do
        expect(content_block.to_s).to be_a(String)
        expect(content_block.inspect).to be_a(String)
      end

      it 'gives the user a json' do
        expect(content_block.as_json).to be_a(Hash)
      end

      it 'let the user to pretty print' do
        expect{ pp content_block }.to output("\n\t\t\t{ \"key\": \"value\" }\n\t\t\n\n").to_stdout
      end

      it 'gives the user a timestamp as json' do
        expect(exclusive_begin_timestamp.as_json).to be_a(DateTime)
        expect(inclusive_end_timestamp.as_json).to be_a(DateTime)
      end
    end
  end
end
