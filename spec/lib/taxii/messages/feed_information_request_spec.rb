require 'spec_helper'

describe Taxii::Messages::FeedInformationRequest do
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
  context 'rendering xml'
end
