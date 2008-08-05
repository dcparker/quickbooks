# This is a fake adapter simply for testing Qbxml Requests.
module Quickbooks
  module TestAdapter
    class Connection
      def initialize(*args)
      end

      # Returns true if there is an open connection to Quickbooks, false if not. Use session? to determine an open session.
      def connected?
        @connected ||= false
      end

      # Sends a request to Quickbooks. This request should be a valid QBXML request. Use Qbxml::Request to generate valid requests.
      def send_xml(xml)
        return xml.to_s
      end

      # Returns the active connection to Quickbooks, or creates a new one if none exists.
      def connection
        @connected = true
      end
    end
  end
end
