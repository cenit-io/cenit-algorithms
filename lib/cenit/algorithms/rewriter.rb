require 'parser/current'

module Cenit
  module Algorithms
    class Rewriter < Parser::Rewriter

      attr_reader :logs

      def initialize(options = {})
        @options = options || {}
        @logs = options[:logs] || {}
        @self_linker = options[:self_linker]
        @interpreter = options[:interpreter]
      end

      def on_send(node)
        super
        if node.children[0].nil? && node.type == :send
          method_name = node.children[1]
          if @self_linker && !@self_linker.link?(method_name)
            report_error("error linking #{method_name}")
          end
          (@logs[:self_sends] ||= Set.new) << method_name
          if @interpreter
            prefix = @interpreter.__prefix__(method_name, @self_linker)
            insert_before(node.location.expression, prefix)
          end
        end
      end

      private

      def report_error(message)
        if @options[:halt_on_error]
          fail message
        else
          (logs[:errors] ||= []) << message
        end
      end
    end
  end
end