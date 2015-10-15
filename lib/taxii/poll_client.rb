module Taxii
  class PollClient
    include Client

    PARSE_OPTIONS = Nokogiri::XML::ParseOptions::DEFAULT_XML | Nokogiri::XML::ParseOptions::NOBLANKS
    CONTENT_XPATH = '/taxii_11:Poll_Response/taxii_11:Content_Block/taxii_11:Content'

    def get( poll_request_message, url: self.poll_service_url)
      msg = format_request(poll_request_message)
      build_request(url: url, payload: msg).execute
    end

    def get_content_blocks( poll_request_message,
                            url: self.poll_service_url,
                            xpath: CONTENT_XPATH )
      response = self.get(poll_request_message, url: url)
      content_xml = Nokogiri::XML(response.body,nil,nil,PARSE_OPTIONS)
      content_xml.xpath(xpath).flat_map { |blk| blk.children.map(&:to_s) }
    end

    def format_request(request_message)
      case request_message
        when String
          request_message
        when Taxii::Messages::PollRequest
          request_message.to_xml
        else
          fail ArgumentError, 'request message must be String or PollRequest'
      end
    end
  end
end
