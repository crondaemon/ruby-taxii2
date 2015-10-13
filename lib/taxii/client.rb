module Taxii
  module Client
    def self.included(klass)
      klass.class_eval do
        include Taxii::Message
        attr_accessor :url, :user, :pass, :client_cert, :client_key, :ca_cert
        attr_reader   :xml
        def initialize(*args)
          Hash[*args].each {|k,v| self.send(format('%s=',k),v)}
          @user ||= 'admin'
          @pass ||= 'avalanche'
          @xml = Nori.new(strip_namespaces: true)
          self
        end
      end
    end

    def build_request(path: 'taxii-discovery-service',payload: {}, format: Taxii::Message::TAXII_11_MESSAGE)
      uri =  File.join(self.url, path)
      RestClient::Request.new(
        method:   :post,
        url:      uri,
        user:     user,
        password: pass,
        payload:  payload,
        timeout:  nil,
        headers: {
          'X-Taxii-Services' => 'urn:taxii.mitre.org:services:1.1',
          :content_type      => 'application/xml',
          :accept            => 'application/xml'
        }.merge(format)
         .merge(scheme_protocol)
      )
    end

    def scheme_protocol
      case URI.parse(url).scheme
        when "http"
          { 'X-Taxii-Protocol' => 'urn:taxii.mitre.org:protocol:http:1.0' }
        when "https"
          { 'X-Taxii-Protocol' => 'urn:taxii.mitre.org:protocol:https:1.0' }
        else
          {}
      end
    end
  end
end