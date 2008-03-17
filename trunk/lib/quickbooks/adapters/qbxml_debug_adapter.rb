# This is a fake adapter simply for testing Qbxml Requests.
module Quickbooks
  module QbxmlDebugAdapter
    class Connection
      def send_xml(xml)
        puts "Sending XML: #{xml.to_s}"
      end
    end
  end
end
