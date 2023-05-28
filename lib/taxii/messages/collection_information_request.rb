module Taxii
  module Messages
    class CollectionInformationRequest < Hashie::Dash
      property :message_id, default: -> { Taxii::Messages.generate_id }

      def to_h
        Taxii::Messages::NAMESPACE_ATTRIBUTES.merge({
          '@message_id': message_id
        })
      end

      def to_xml
        Gyoku.xml({'taxii_11:Collection_Information_Request/': to_h}, key_converter: :none)
      end

    end
  end
end
