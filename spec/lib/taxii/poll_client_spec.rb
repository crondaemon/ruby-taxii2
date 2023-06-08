require 'spec_helper'

describe Taxii::PollClient do
  let(:spec_client) { Taxii.configure(config: 'spec/fixtures/config-otx.json') }

  context 'generating requests'
  context 'discovering collections' do
    describe '.discover_collections' do
      it 'returns info for collections' do
        VCR.use_cassette('discover_collections') do
          expect(spec_client.discovery_service_url).to eq('https://otx.alienvault.com/taxii/discovery')
          expect(spec_client.inbox_service_url).to be_nil
          collections = spec_client.discover_collections(format: {})
          expect(collections).to be_a(Array)
          expect(collections.count).to be > 0
        end
      end
    end
  end

  context 'poll data' do
    describe '.poll' do
      it 'returns data from polling' do
        VCR.use_cassette('poll') do
          collection_name = spec_client.discover_collections(format: {}).first['@collection_name']
          expect(collection_name).to eq('user_AlienVault')
          poll_request_message = Taxii::Messages::PollRequest.new(
            collection_name: collection_name,
            poll_parameters: Taxii::Messages::Parameters::Poll.new(response_type: 'FULL'),
            exclusive_begin_timestamp: Time.now - 3600 * 6
          )
          blocks = spec_client.get_content_blocks(poll_request_message)
          expect(blocks).to be_a(Array)
          expect(blocks.count).to eq(4)
          blocks.each do |block|
            expect{ Taxii.parse(block) }.to_not raise_error
          end
        end
      end

      it 'sends Poll_Fulfillment' do
        VCR.use_cassette('poll_fulfillment') do
          poll_request_message = Taxii::Messages::PollRequest.new(
            collection_name: 'user_AlienVault',
            poll_parameters: Taxii::Messages::Parameters::Poll.new(response_type: 'FULL'),
            exclusive_begin_timestamp: Time.now - 3600 * 24 * 10
          )
          blocks = spec_client.get_content_blocks(poll_request_message)
          expect(blocks).to be_a(Array)
          expect(blocks.count).to eq(31)
        end
      end
    end
  end
end
