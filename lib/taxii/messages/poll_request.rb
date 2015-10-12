module Taxii
  module Messages
    NAMESPACE_ATTRIBUTES={
      '@xmlns:taxii':    'http://taxii.mitre.org/messages/taxii_xml_binding-1',
      '@xmlns:taxii_11': 'http://taxii.mitre.org/messages/taxii_xml_binding-1.1',
      '@xmlns:tdq':      'http://taxii.mitre.org/query/taxii_default_query-1'
    }
    TS_FORMAT='%Y-%m-%dT%H:%M:%S%:z'
    module Parameters
      class Delivery
        attr_accessor :protocol_binding, :address, :message_binding
        def intialize(*args)
          Hash[*args].each {|k,v| self.send(format('%s=',k),v)}
          self
        end
      end

      class Poll < Hashie::Dash
        property :allow_asynch,  default: false
        property :response_type, default: 'COUNT_ONLY'
        property :content_binding

        def response_type=(type)
          unless %w{ FULL COUNT_ONLY }.include?(type)
            fail ArgumentError, "#{type} must be FULL or COUNT_ONLY"
          end
          @response_type=type
        end

        def to_h
          {
              '@allow_asynch':          allow_asynch,
              'taxii_11:Response_Type': response_type
          }
        end
        def to_xml
          content_hash = if content_binding.nil?
            self.to_h
          else
            self.to_h.merge('taxii_11:Content_Binding!': content_binding)
          end

          Gyoku.xml({'taxii_11:Poll_Parameters': content_hash}, key_converter: :none)
        end
      end
    end

    class PollRequest < Hashie::Dash
      include Hashie::Extensions::Coercion

      property :collection_name, default: 'system.Default'
      property :message_id, default: -> { format('%012d%08d',Time.new.to_i,$$)} 
      property :exclusive_begin_timestamp
      property :inclusive_end_timestamp
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