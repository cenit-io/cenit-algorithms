require 'cenit/algorithms/interpreter'

module Cenit
  module Algorithms
    class Algorithm

      attr_reader :json

      def initialize(json)
        @json = json
      end

      def id
        @id ||= json['id'] || object_id.to_s
      end

      def namespace
        json['namespace']
      end

      def name
        json['name']
      end

      def parameters
        json['parameters'] || []
      end

      def code
        json['snippet']['code']
      end

      def call_links
        json['call_links'] || []
      end

      def link?(name)
        name = name.to_s
        call_links.any? { |call_link| call_link['name'] == name }
      end

      def link(name)
        name = name.to_s
        call_link = call_links.detect { |call_link| call_link['name'] == name }
        if call_link
          Algorithms.find(id: call_link['link']['id'],
                          namespace: call_link['link']['namespace'],
                          name: call_link['link']['name'])
        else
          fail "Error linking #{name}"
        end
      end

      def run(*args)
        Interpreter.run(self, *args)
      end
    end
  end
end