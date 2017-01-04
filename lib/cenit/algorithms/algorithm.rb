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
        response = HTTParty.post Api.base_url(id: id, action: :run), {
          headers: Api.headers,
          body: args.to_json
        }
        if response.code == 200
          execution = JSON.parse(response.body)
          until %w(completed failed broken).include?(execution['status'])
            sleep 1
            response = HTTParty.get Api.base_url(model: 'execution', id: execution['id']), {
              headers: Api.headers
            }
            fail response.to_json unless response.code == 200
            execution = JSON.parse(response.body)
          end
          execution['attachment_content'] || fail("Error running #{namespace} | #{name}")
        else
          fail response.to_json
        end
      end
    end
  end
end