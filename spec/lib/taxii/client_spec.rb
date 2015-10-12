require 'spec_helper'
describe Taxii::Client do
  let(:spec_client_cls) { 
    class SpecClient
      include Taxii::Client
    end
  }

  let(:spec_client) { Taxii.configure(
    config: 'spec/fixtures/config-basic_auth_http.json',
    client:  spec_client_cls
  )}

  let(:spec_client_https) { Taxii.configure(
    config: 'spec/fixtures/config-basic_auth_https.json',
    client:  spec_client_cls
  )}

  context 'defining classes' do
    describe '.included' do
      it 'defines config getters and setters' do
        expect(spec_client).to  respond_to(:url)
        expect(spec_client).to  respond_to(:user)
        expect(spec_client).to  respond_to(:pass)
        expect(spec_client).to  respond_to(:client_cert)
        expect(spec_client).to  respond_to(:client_key)
        expect(spec_client).to  respond_to(:ca_cert)
      end
      it 'also includes the Taxii::Message module' do
        expect(spec_client).to  be_a_kind_of(Taxii::Message)
      end
      it 'adds a nori parser' do
        expect(spec_client.xml).to  be_a(Nori)
      end
    end
  end

  context 'building client requests' do
    describe '#scheme_protocol' do
      it 'returns an X-Taxii-Protocol for http clients' do
        expect(spec_client.scheme_protocol.values).to eq(['urn:taxii.mitre.org:protocol:http:1.0'])
      end
      it 'returns an X-Taxii-Protocol for https clients' do
        expect(spec_client_https.scheme_protocol.values).to eq(['urn:taxii.mitre.org:protocol:https:1.0'])
      end
    end
    describe '#build_request' do
      it 'returns RestClient::Request objects' do
        req = spec_client.build_request
        expect(req).to be_a(RestClient::Request)
      end
      it 'sets content-type/accept headers for taxii 1.0 messages' do
        req = spec_client.build_request(format: Taxii::Message::TAXII_10_MESSAGE)
        expect(req.headers).to include(
          'X-Taxii-Accept'       => 'urn:taxii.mitre.org:message:xml:1.0',
          'X-Taxii-Content-Type' => 'urn:taxii.mitre.org:message:xml:1.0'
        )
      end
      it 'sets content-type/accept headers for taxii 1.1 messages' do
        req = spec_client.build_request(format: Taxii::Message::TAXII_11_MESSAGE)
        expect(req.headers).to include(
          'X-Taxii-Accept'       => 'urn:taxii.mitre.org:message:xml:1.1',
          'X-Taxii-Content-Type' => 'urn:taxii.mitre.org:message:xml:1.1'
        )
      end
    end
  end
end