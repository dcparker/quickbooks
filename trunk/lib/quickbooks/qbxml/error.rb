module Quickbooks
  module Qbxml
    # This class exists simply to wrap errors in an object similar in structure to a Quickbooks::Base-inherited object, so the error can be extracted, etc.
    class Error
      # Stores a log of Quickbooks::Qbxml::Response objects that were a result of methods performed on this object.
      attr_accessor :response_log
      def response_log #:nodoc:
        @response_log || (@response_log = [])
      end

      # Returns success (true/false) status of the last quickbooks communication called from this object.
      def success?
        @response_log.last.success?
      end
      def inspect #:nodoc:
        "#<#{self.class.name}:#{self.object_id} #{instance_variables.reject {|i| i.is_one_of?('@response_log', '@original_values')}.map {|i| "#{i}=#{instance_variable_get(i).inspect}"}.join(' ')}>"
      end
    end
  end
end
