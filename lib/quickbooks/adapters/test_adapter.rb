# This is a fake adapter simply for testing Qbxml Requests.
module Quickbooks
  module TestAdapter
    class Connection
      def initialize(*args)
      end

      def next_response(value, &block)
        @next_value = value
        @next_block = block
      end

      # Returns true if there is an open connection to Quickbooks, false if not. Use session? to determine an open session.
      def connected?
        @connected ||= false
      end

      # Sends a request to Quickbooks. This request should be a valid QBXML request. Use Qbxml::Request to generate valid requests.
      def send_xml(xml)
        @next_block.call(xml) if @next_block
        raise RuntimeError, "You must call next_response to set up the next response xml manually for the TestAdapter." unless @next_value
        return @next_value
      end

      # Returns the active connection to Quickbooks, or creates a new one if none exists.
      def connection
        @connected = true
      end
    end
  end
end
