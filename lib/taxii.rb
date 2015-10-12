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

    TAXII_11_MESSAGE = {
      'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.1',
      'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.1'
    }

    TAXII_10_MESSAGE = {
      'X-Taxii-Accept'        => 'urn:taxii.mitre.org:message:xml:1.0',
      'X-Taxii-Content-Type'  => 'urn:taxii.mitre.org:message:xml:1.0'
    }

    ENVELOPE = {
      'xmlns:taxii'    => 'http://taxii.mitre.org/messages/taxii_xml_binding-1',
      'xmlns:taxii_11' => 'http://taxii.mitre.org/messages/taxii_xml_binding-1.1',
      'xmlns:tdq'      => 'http://taxii.mitre.org/query/taxii_default_query-1'
    }

    def message_id
      @mid_seq ||= 1000
      @mid_seq += 1
    end

    def discovery_request
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii_11'].Discovery_Request(
          'message_id' => message_id
          )
      end
      build.doc.to_s
    end

    def poll_request(collection_name: 'Default')
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii_11'].Poll_Request(
          ENVELOPE.merge(
            'message_id'      => message_id,
            'collection_name' => collection_name
          )
        ) do
          xml['taxii_11'].Poll_Parameters( 'allow_asynch' => 'false' ) do
            xml['taxii_11'].Response_Type('FULL')
          end
        end
      end
      build.doc.to_s
    end

    def feed_information_request
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii'].Feed_Information_Request(
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
      @xml = Nori.new(strip_namespaces: true)
      self
    end

    def discover_services(path: 'taxii-discovery-service')
      req = build_request(path: path, payload: discovery_request)
      resp = req.execute
      parsed  = xml.parse(resp.body)
      parsed['Discovery_Response']['Service_Instance']
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

    def discover_feeds(path: 'taxii-data')
      req = build_request(path: path, payload: feed_information_request, format:  TAXII_10_MESSAGE)
      resp = req.execute
      parsed = xml.parse(resp.body)
      parsed['Feed_Information_Response']['Feed']
    end

    def poll_service_available?
      discover_services.any? {|s| s['@service_type'].match(/POLL/i) && s['@available']=='true'}
    end

    def poll_feed(path: 'taxii-data', collection_name: 'Default')
      payload = poll_request(collection_name: collection_name)
      req = build_request(path: path, payload: payload)
      resp = req.execute
      parsed = xml.parse(resp.body)
    end

    def build_request(path: 'taxii-discovery-service',payload: {}, format: TAXII_11_MESSAGE)
      uri =  File.join(self.url, path)
      RestClient::Request.new(
        method:   :post,
        url:      uri,
        user:     user,
        password: pass,
        payload:  payload,
        headers: {
          'X-Taxii-Services' => 'urn:taxii.mitre.org:services:1.1',
          :content_type      => 'application/xml',
          :accept            => 'application/xml'
        }.merge(format)
         .merge(scheme_protocol)
      )
    end
  end
end
