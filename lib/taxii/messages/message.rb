require 'json'

module Taxii
  module Messages
    class Message
      def initialize(body)
        parsed = Nori.new(strip_namespaces: true).parse(body)
        @body = parsed.dig(*self.class.object_path)
      end

      def to_s
        @body.to_s
      end

      def inspect
        self.to_s
      end

      def as_json
        JSON.parse(@body)
      end

      def pretty_print(pp)
        puts self.to_s
      end
    end
  end
end
