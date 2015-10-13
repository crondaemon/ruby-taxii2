module Taxii
  class PollClient
    include Client

    def poll_request_full_message(collection_name: 'Default')
      build = Nokogiri::XML::Builder.new do |xml|
        xml['taxii_11'].Poll_Request(
          NAMESPACES.merge(
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

    def poll_feed(poll_request=gen_request)
      request  = build_request(path: 'taxii-data', payload: poll_request.to_xml)
      response = request.execute
    end
  end
end
