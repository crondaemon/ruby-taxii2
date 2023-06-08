module Taxii
  module Messages
    class RecordCount < Message
      def self.object_path
        ['Record_Count']
      end
    end
  end
end
