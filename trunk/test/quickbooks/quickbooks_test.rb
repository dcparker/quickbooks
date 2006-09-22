require File.dirname(__FILE__) + '/../test_helper'

class QuickBooksTest < Test::Unit::TestCase
  include QuickBooks
  def setup
    Models::Base.establish_connection('admin', 'pass123', 'My Test App')
  end
  
  # This test assumes you have RDS configured with the following name and password
  # and that you are using the sample company that comes with QuickBooks.
  def test_connection        
    connection = Connection.new('admin', 'pass123', 'My Test App')
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
    res = connection.send_raw(xml)
    assert_not_nil(res)
  end
  
  def test_model_connection
      assert_not_nil(Models::Base.connection)
  end
  
  def test_customer_query
    puts Models::Customer.find("Kristy Abercrombie")
  end
end