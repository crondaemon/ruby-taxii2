module Taxii
  module Messages
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
  end
end
