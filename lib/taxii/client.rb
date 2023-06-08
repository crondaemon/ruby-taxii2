module Taxii
  module Client
    def self.included(klass)
      klass.class_eval do
        attr_accessor :url, :user, :pass, :logger, :client_cert, :client_key, :ca_cert
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

    def build_request(url: self.url, payload: {}, format: Taxii::Messages::TAXII_11_HEADERS)
      RestClient::Request.new(
        method:   :post,
        url:      url,
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

    def get_service_address(service_name)
      service = discover_services.find do |svc|
        svc['@service_type'] == service_name && svc['@available'] == 'true'
      end
      service.nil? ? nil : service['Address']
    end

    def discover_services
      payload  = Taxii::Messages::DiscoveryRequest.new.to_xml
      response = build_request(url: self.url, payload: payload).execute
      parsed   = xml.parse(response.body)
      parsed['Discovery_Response'].fetch('Service_Instance',[])
    end

    def discovery_service_url
      self.url
    end

    def inbox_service_url
      @inbox_service_url ||= get_service_address('INBOX')
    end
    
    def collection_management_service_url
      @collection_management_service_url ||= get_service_address('COLLECTION_MANAGEMENT')
    end

    def poll_service_url
      @poll_service_url ||= get_service_address('POLL')
    end

    def discover_feeds(url = self.collection_management_service_url)
      msg  = Taxii::Messages::FeedInformationRequest.new.to_xml
      http  = build_request(url: url, payload: msg, format: Taxii::Messages::TAXII_10_HEADERS)
      parsed  = xml.parse(http.execute.body)
      parsed['Feed_Information_Response'].fetch('Feed', [])
    end

    def discover_collections(url = self.collection_management_service_url)
      msg  = Taxii::Messages::CollectionInformationRequest.new.to_xml
      http  = build_request(url: url, payload: msg, format: Taxii::Messages::TAXII_10_HEADERS)
      parsed  = xml.parse(http.execute.body)
      parsed['Collection_Information_Response'].fetch('Collection', [])
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
