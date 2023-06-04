require 'spec_helper'

describe Taxii do
  it 'has a version number' do
    expect(Taxii::VERSION).not_to be nil
  end
  context 'configuring clients' do
    let(:arbitrary_client_cls) {
      class ArbitraryClient
        include Taxii::Client
      end
    }

    describe '.configure' do
      it 'creates arbitrary client classes when passed in' do
        arbitrary = Taxii.configure(
          config: 'spec/fixtures/config-basic_auth_http.json',
          client: arbitrary_client_cls
        )
        expect(arbitrary).to have_attributes({
          user: 'basic',
          pass: 'Basic0(*&',
          url:  'http://taxii.local/taxii-discovery-service'
        })
      end

      it 'creates an http/basic poll client' do
        basic_http = Taxii.configure(
          config: 'spec/fixtures/config-basic_auth_http.json',
          client: Taxii::PollClient
        )
        expect(basic_http).to have_attributes({
          user: 'basic',
          pass: 'Basic0(*&',
          url:  'http://taxii.local/taxii-discovery-service'
        })
      end
      it 'creates PollClient instances by default' do
        default_client = Taxii.configure(
          config: 'spec/fixtures/config-basic_auth_http.json'
        )
        expect(default_client).to be_a(Taxii::PollClient)
      end
      it 'tries to load ~/.taxii.json config by default' do
        if File.exist?(File.join(ENV['HOME'],'.taxii.json'))
          expect(Taxii.configure).to be_a(Taxii::PollClient)
        else
          expect{ default_config = Taxii.configure }.to raise_error(RuntimeError, /You must provide user\+pass\+url/)
        end
      end
    end
  end
end
