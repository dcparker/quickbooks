require 'sha1'
# This is a fake adapter simply for testing Qbxml Requests.
module Quickbooks
  module TestAdapter
    class Connection
      def initialize(*args)
        @stored_responses = {}
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
        xml = xml.gsub(/ requestID=\"\d+\"/,'')
        @next_block.call(xml) if @next_block
        returning = caching(xml, @next_value)
        raise RuntimeError, "You must call next_response to set up the next response xml manually for the TestAdapter." unless returning
        @next_value = nil
        @next_block = nil
        return returning
      end

      # Returns the active connection to Quickbooks, or creates a new one if none exists.
      def connection
        @connected = true
      end

      private
        def caching(key,value=nil)
          @stored_responses[SHA1.hexdigest(key)] || begin
            puts "Requesting: #{key}"
            @stored_responses[SHA1.hexdigest(key)] = value
          end
        end
    end
  end
end
