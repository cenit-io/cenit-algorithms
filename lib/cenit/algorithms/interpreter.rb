require 'cenit/algorithms/rewriter'

module Cenit
  module Algorithms
    class Interpreter

      def initialize
        @__prefixes__ = Hash.new do |linkers, linker_id|
          linkers[linker_id] = Hash.new do |methods, method|
            methods[method] = "__#{linker_id}_"
          end
        end
        @__algorithms__ = {}
        @__options__ = {}
      end

      def method_missing(symbol, *args, &block)
        if (algorithm = @__algorithms__[symbol.to_s])
          if algorithm.is_a?(Proc)
            define_singleton_method(symbol, algorithm)
          else
            instance_eval "define_singleton_method(:#{symbol},
          ->(#{algorithm.parameters.collect { |p| p['name'] }.join(', ')}) {
            #{__parse__(algorithm)}
          })"
          end
          send(symbol, *args, &block)
        else
          super
        end
      end

      def respond_to?(*args)
        @__algorithms__.has_key?(args[0])
      end

      def __run__(algorithm, *args)
        run_name ="__run__#{algorithm.name}"
        @__algorithms__[run_name] = algorithm
        send run_name, *args
      end

      def __prefix__(method, linker)
        prefix = @__prefixes__[linker.id][method]
        @__algorithms__[prefix + method.to_s] = linker.link(method)
        prefix
      end

      def __parse__(algorithm)
        code = algorithm.code
        algorithm.parameters.each do |p|
          code = "#{p['name']} ||= nil\r\n" + code
        end
        buffer = ::Parser::Source::Buffer.new('code')
        buffer.source = code
        ast = Parser::CurrentRuby.new.parse(buffer)
        Rewriter.new(self_linker: algorithm, interpreter: self).rewrite(buffer, ast)
      end

      class << self
        def run(algorithm, *args)
          new.__run__(algorithm, *args)
        end
      end

    end
  end
end