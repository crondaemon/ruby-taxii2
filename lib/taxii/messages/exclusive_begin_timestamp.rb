module Taxii
  module Messages
    class ExclusiveBeginTimestamp < Message
      def self.object_path
        ['Exclusive_Begin_Timestamp']
      end

      def as_json
        @body
      end
    end
  end
end
