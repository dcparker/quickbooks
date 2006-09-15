require File.dirname(__FILE__) + '/../test_helper'

class QuickBooksTest < Test::Unit::TestCase
  def setup		
  end
  
  # This test assumes you have RDS configured with the following name and password
  # and that you are using the sample company that comes with QuickBooks.
  def test_connection        
    connection = QuickBooks::Connection.new('admin', 'pass123', 'My Test App')
    connection.open
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
    res = connection.send(xml)
    assert_not_nil(res)
    connection.close 
  end
  
  def test_model_connection
      QuickBooks::Models::Base.establish_connection('admin', 'pass123', 'My Test App')
      assert_not_nil(QuickBooks::Models::Base.connection)
  end
  
end