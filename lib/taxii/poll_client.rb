module Taxii
  class PollClient
    include Client

    PARSE_OPTIONS = Nokogiri::XML::ParseOptions::DEFAULT_XML | Nokogiri::XML::ParseOptions::NOBLANKS
    POLL_RESPONSE_PATH = '/taxii_11:Poll_Response'
    CONTENT_XPATH = "#{POLL_RESPONSE_PATH}/taxii_11:Content_Block/taxii_11:Content"

    def get(poll_request_message, url: self.poll_service_url)
      msg = format_request(poll_request_message)
      build_request(url: url, payload: msg).execute
    end

    def get_content_blocks(poll_request_message,
                            url: self.poll_service_url,
                            xpath: CONTENT_XPATH)
      response = self.get(poll_request_message, url: url)
      @content_xml = Nokogiri::XML(response.body, nil, nil, PARSE_OPTIONS)

      blocks = response_blocks

      # We have a muulti-part message
      # http://docs.oasis-open.org/cti/taxii/v1.1.1/cs01/part2-services/taxii-v1.1.1-cs01-part2-services.html#_Toc450734190
      while attribute_more == 'true'
        poll_fulfillment_message = Taxii::Messages::PollFulfillmentRequest.new(
          collection_name: poll_request_message.collection_name,
          result_id: result_id,
          result_part_number: result_part_number + 1)

        response = self.get(poll_fulfillment_message, url: url)
        @content_xml = Nokogiri::XML(response.body, nil, nil, PARSE_OPTIONS)

        blocks += response_blocks
      end

      blocks
    end

    private

    def response_blocks
      @content_xml.xpath(POLL_RESPONSE_PATH).flat_map { |blk| blk.children.map(&:to_s) }
    end

    def attribute_more
      @content_xml.at_xpath(POLL_RESPONSE_PATH).attributes['more'].value
    end

    def result_id
      @content_xml.at_xpath(POLL_RESPONSE_PATH).attributes['result_id'].value
    end

    def result_part_number
      @content_xml.at_xpath(POLL_RESPONSE_PATH).attributes['result_part_number'].value.to_i
    end

    def format_request(request_message)
      case request_message
        when String
          request_message
        when Taxii::Messages::PollRequest, Taxii::Messages::PollFulfillmentRequest
          request_message.to_xml
        else
          fail ArgumentError, 'request message must be String or PollRequest'
      end
    end
  end
end
