module Taxii
  module Messages
    class PollRequest < Hashie::Dash
      include Hashie::Extensions::Coercion

      property :collection_name, default: 'system.Default'
      property :message_id, default: -> { Taxii::Messages.generate_id }
      property :exclusive_begin_timestamp, default: -> { Time.new - 3600 }
      property :inclusive_end_timestamp, default: -> { Time.new }
      property :subscription_id
      property :poll_parameters,
                 required: -> { subscription_id.nil? },
                 default: Taxii::Messages::Parameters::Poll.new
      property :query
      property :delivery_parameters

      coerce_key :exclusive_begin_timestamp, Time
      coerce_key :inclusive_end_timestamp, Time

      def requested_begin
        if exclusive_begin_timestamp.nil?
          {}
        else
          {'Exclusive_Begin_Timestamp': exclusive_begin_timestamp.strftime(TS_FORMAT)}
        end
      end

      def requested_end
        if inclusive_end_timestamp.nil?
          {}
        else
          {'Inclusive_End_Timestamp': inclusive_end_timestamp.strftime(TS_FORMAT)}
        end
      end
      def requested_info
        if subscription_id.nil?
          {'taxii_11:Poll_Parameters': poll_parameters.to_h}
        else
          {'taxii_11:Subscription_ID': subscription_id}
        end
      end

      def to_h
        NAMESPACE_ATTRIBUTES.merge({
          '@message_id':      message_id,
          '@collection_name': collection_name
        }).merge(requested_begin)
          .merge(requested_end)
          .merge(requested_info)
      end

      def to_xml
        Gyoku.xml({'taxii_11:Poll_Request': to_h}, key_converter: :none)
      end

    end
  end
end
