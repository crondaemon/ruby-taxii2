require 'spec_helper'

describe Taxii::Messages::PollRequest do
  let(:spec_parser) { Nori.new }
  let(:t_begin)     { Time.at(166813200)}
  let(:t_end)       { Time.at(166814200)}

  context 'describing class configuration' do
    describe 'Hashie.property' do
      it 'defines message properties' do
        expect(Taxii::Messages::PollRequest.properties).to eq(
          Set.new([:collection_name, :message_id, :exclusive_begin_timestamp,
                   :inclusive_end_timestamp, :subscription_id, :poll_parameters,
                   :query, :delivery_parameters])
        )
      end
    end
  end

  context 'initializing instances' do
    let(:default_pr) {Taxii::Messages::PollRequest.new}
    describe '.initialize' do
      it 'instantiates without arguments' do
        expect(default_pr).to be_a(Taxii::Messages::PollRequest)
      end

      it 'sets defaults when intiailized without arguments' do
        expect(default_pr).to have_attributes(collection_name: 'system.Default')
        expect(default_pr.message_id).to match(%r{\A[0-9]+\z})
      end
      it 'adds poll_parameters when no subscription_id is present' do
        expect(default_pr.poll_parameters).to be_a(Taxii::Messages::Parameters::Poll)
      end
    end
  end
  context 'rendering xml with a subscription id' do
    let(:pr) { Taxii::Messages::PollRequest.new(
      message_id:      '10101',
      subscription_id: 'SUB-ID-999'
    )}
    let(:pr_xml) { pr.to_xml }
    describe '#to_xml' do
      it 'renders the request' do
        expect(pr_xml).to match(%r{<taxii_11:Subscription_ID>SUB-ID-999</taxii_11:Subscription_ID>})
      end
      it 'does not include Poll_Parameters' do
        expect(pr_xml).not_to match(%r{Poll_Parameters})
      end
    end
  end
  context 'rendering xml with poll parameters' do
    let(:pp)     { Taxii::Messages::Parameters::Poll.new }
    let(:pr)     { Taxii::Messages::PollRequest.new(
      message_id:      '10101',
      poll_parameters: pp
    )}
    let(:pr_xml) { pr.to_xml }
    describe '#to_xml' do
      it 'renders the request' do
        expect(pr_xml).to match(%r{\A<taxii_11:Poll_Request})
      end
      it 'renders the poll_parameters' do
        expect(pr_xml).to match(pp.to_xml)
      end
      it 'does not render a subscription_id' do
        expect(pr_xml).not_to match(%r{Subscription_ID})
      end
    end
  end
end
