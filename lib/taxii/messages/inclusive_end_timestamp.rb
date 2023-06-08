module Taxii
  module Messages
    class InclusiveEndTimestamp < Message
      def self.object_path
        ['Inclusive_End_Timestamp']
      end

      def as_json
        @body
      end
    end
  end
end
