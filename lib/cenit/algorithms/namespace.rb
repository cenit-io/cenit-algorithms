require 'cenit/algorithms/algorithm'

module Cenit
  module Algorithms
    class Namespace

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def method_missing(symbol, *args)
        Algorithms.find(namespace: name, name: symbol.to_s).run(*args)
      end
    end
  end
end