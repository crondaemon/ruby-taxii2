module Taxii
  module Messages
    class ContentBlock < Message
      def self.object_path
        ['Content_Block', 'Content']
      end
    end
  end
end
