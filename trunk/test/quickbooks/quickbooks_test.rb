require File.dirname(__FILE__) + '/../test_helper'

class QuickBooksTest < Test::Unit::TestCase
	def setup		
	end
	
	def test_connection        
      session = QuickBooks::Session.new('admin', 'pass123', 'My Test App')
      session.open
      xml = <<EOL
<?xml version="1.0"?>
<?qbxml version="3.0"?>
<QBXML>
  <QBXMLMsgsRq onError="continueOnError">
    <InvoiceQueryRq requestID="1">
      <RefNumber>81</RefNumber>
      <IncludeLineItems>true</IncludeLineItems>
    </InvoiceQueryRq>
  </QBXMLMsgsRq>
</QBXML>
EOL
      res = session.send(xml)
      assert_not_nil(res)
      session.close 
	end	

end