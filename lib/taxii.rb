require 'nokogiri'
require 'rest-client'
require 'uri'
require 'nori'

require 'taxii/version'

module Taxii
  def self.configure(config: File.join(ENV['HOME'],'.taxii.json'), client: PollClient)
    configuration = JSON.parse(File.read(config))
    client.new(configuration)
  end
  module Message
    def message_id
      @mid_seq ||= 1000
      @mid_seq += 1
    end
    def discovery_request
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii_11'].Discovery_Request(
          'xmlns:taxii' => 'http://taxii.mitre.org/messages/taxii_xml_binding-1',
          'xmlns:taxii_11' => 'http://taxii.mitre.org/messages/taxii_xml_binding-1.1',
          'xmlns:tdq' => 'http://taxii.mitre.org/query/taxii_default_query-1',
          'message_id' => message_id
          )
      end
      build.doc.to_s
    end
  end
  class PollClient
    include Message

    attr_accessor :url, :user, :pass, :client_cert, :ca_cert
    attr_reader   :xml
    def initialize(*args)
      Hash[*args].each {|k,v| self.send(format('%s=',k),v)}
      @user ||= 'admin'
      @pass ||= 'avalanche'
      @xml = Nori.new
      self
    end

    def discover_services
      req = build_request(path: 'taxii-discovery-service', payload: discovery_request)
      resp = req.execute
      parsed  = xml.parse(resp.body)
      parsed['taxii_11:Discovery_Response']['taxii_11:Service_Instance']
    end

    def poll_service_available?
      discover_services.any? {|s| s['@service_type'].match(/POLL/i) && s['@available']=='true'}
    end
    
    def build_request(path: 'taxii-discovery-service',payload: {})
      uri =  File.join(self.url, path)
      RestClient::Request.new(
        method:   :post,
        url:      uri,
        user:     user,
        password: pass,
        payload:  payload,
        headers: {
          content_type: 'application/xml',
          accept:  :xml,
          'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.1',
          'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.1',
          'X-Taxii-Protocol'      => 'urn:taxii.mitre.org:protocol:http:1.0',
          'X-Taxii-Services'      => 'urn:taxii.mitre.org:services:1.1'
        }
      )
    end
  end
end
