require 'cenit/algorithms/version'
require 'cenit/config'
require 'cenit/algorithms/namespace'
require 'httparty'

module Cenit

  class << self

    def Algorithms(ns_or_criteria)
      case ns_or_criteria
      when String
        Algorithms::Namespace.new(ns_or_criteria)
      when Hash
        Cenit::Algorithms.find(ns_or_criteria)
      else
        fail "#{String} or #{Hash} expected but #{ns_or_criteria.class} found"
      end
    end
  end

  module Algorithms

    class << self

      def find(criteria)
        id = criteria[:id] || criteria['id']
        if (algorithm = cache[id])
          return algorithm
        end
        namespace = criteria[:namespace] || criteria['namespace']
        name = criteria[:name] || criteria['name']
        if namespace && name && (algorithm = indexed[namespace][name])
          return algorithm
        end
        algorithm = retrieve(criteria)
        indexed[algorithm.namespace][algorithm.name] = cache[algorithm.id] = algorithm
        algorithm
      end

      def reset
        cache.clear
        indexed.clear
        self
      end

      private

      def cache
        @algorithms ||= {}
      end

      def indexed
        @indexed ||= Hash.new { |h, k| h[k] = {} }
      end

      def retrieve(criteria)
        query = criteria.dup
        id = query.delete('id')
        id = query.delete(:id) || id
        headers = { 'Content-Type' => 'application/json' }
        if (token = Cenit.access_token) && (key = Cenit.access_key)
          headers['X-User-Access-Key'] = key
          headers['X-User-Access-Token'] = token
        end
        url = "#{Cenit.host}/api/v2/setup/algorithm"
        if id
          url += "/#{id}"
          query = {}
        end
        query[:embedding] = 'snippet'
        response = HTTParty.get url, { headers: headers, query: query }
        if response.code == 200
          json = JSON.parse(response.body)
          if id || json['count'] == 1
            json = id ? json : json['algorithms'][0]
            Algorithm.new(json)
          else
            fail "Algorithm not found with criteria #{criteria}"
          end
        else
          fail response.to_json
        end
      end
    end
  end
end
