module Taxii
  module Messages
    class PollFulfillmentRequest < Hashie::Dash
      include Hashie::Extensions::Coercion

      property :collection_name, default: 'system.Default'
      property :result_id
      property :result_part_number
      property :message_id, default: -> { Taxii::Messages.generate_id }

      def to_h
        NAMESPACE_ATTRIBUTES.merge({
          '@message_id':         message_id,
          '@collection_name':    collection_name,
          '@result_id':          result_id,
          '@result_part_number': result_part_number,
        })
      end

      def to_xml
        Gyoku.xml({'taxii_11:Poll_Fulfillment': to_h}, key_converter: :none)
      end
    end
  end
end
