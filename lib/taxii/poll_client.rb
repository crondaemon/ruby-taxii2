module Taxii
  class PollClient
    include Client

    PARSE_OPTIONS = Nokogiri::XML::ParseOptions::DEFAULT_XML | Nokogiri::XML::ParseOptions::NOBLANKS
    def poll_service_available?
      discover_services.any? {|s| s['@service_type'].match(/POLL/i) && s['@available']=='true'}
    end

    def discover_services(path: 'taxii-discovery-service')
      payload  = discovery_request_message
      request  = build_request(path: path, payload: payload)
      response = request.execute
      parsed   = xml.parse(response.body)
      parsed['Discovery_Response'].fetch('Service_Instance',[])
    end

    def discover_feeds(path: 'taxii-data')
      payload  = feed_information_request_message
      request  = build_request(path: path, payload: payload, format:  TAXII_10_MESSAGE)
      response = request.execute
      parsed   = xml.parse(response.body)
      parsed['Feed_Information_Response'].fetch('Feed',[])
    end

    def gen_request(collection_name: 'system.Default', response_type: 'FULL')
      pparams = Taxii::Messages::Parameters::Poll.new(response_type: response_type)
      Taxii::Messages::PollRequest.new(collection_name: collection_name, poll_parameters: pparams)
    end

    def poll_feed(poll_request=gen_request,parse=true)
      request  = build_request(path: 'taxii-data', payload: poll_request.to_xml)
      response = request.execute
      if parse
        xml = Nokogiri::XML(response.body,nil,nil,PARSE_OPTIONS)
        xml.xpath('/taxii_11:Poll_Response/taxii_11:Content_Block/taxii_11:Content').flat_map do |content|
          content.children.map &:to_s
        end
      else
        response
      end
    end
  end
end
