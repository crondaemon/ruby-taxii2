require 'spec_helper'

describe Taxii::Messages::PollRequest do
  let(:spec_parser) { Nori.new }
  context 'initializing instances' do
    describe '.initialize' do
      it 'instantiates without a message_id argument'
    end
  end
  context 'rendering xml with a subscription id'
  context 'rendering xml with poll parameters'
end
