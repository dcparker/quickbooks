
module QuickBooks
  # Connection is  used to communicate with QuickBooks RDS Server.  You need to configure
  # your QuickBooks software to allow RDS connection from your application.
  # <code>
  #   require 'quickbooks'
  #   
  #   connection = QuickBooks::Connection.new('admin', 'pass', 'My Test App')
  #   connection.open
  #   xml = <<END
  #   <?xml version="1.0"?>
  #   <?qbxml version="3.0"?>
  #   <QBXML>
  #   <QBXMLMsgsRq onError="continueOnError">
  #    <InvoiceQueryRq requestID="1">
  #      <RefNumber>81</RefNumber>
  #      <IncludeLineItems>true</IncludeLineItems>
  #    </InvoiceQueryRq>
  #   </QBXMLMsgsRq>
  #   </QBXML>
  #   <<END
  #   connection.send(xml)
  #   connection.close
  class Connection
    require 'cgi'
    require 'soap/wsdlDriver'
    
    QBXML_VERSION = "3.0"
    
    attr_accessor :user, :password, :application_name, :host, :port
    
    # Initializes an instance of QuickBooks::Session
    def initialize(user, password, application_name, host="localhost", port=3790, mode='multiUser')
      @user = user
      @password = password
      @application_name = application_name
      @host = host
      @port = port
      @mode = mode
      @ticket = nil
      @soap_client = nil      
    end
    
    # Determines if the Session is connected to a QuickBooks RDS Server
    def connected?
      if @ticket && @soap_client
        return true
      end
      return false
    end
    
    # Opens a connection to a QuickBooks RDS Server
    def open
      @soap_client ||= SOAP::WSDLDriverFactory.new("https://#{@host}:#{@port}/QBXMLRemote?wsdl").create_rpc_driver
      @ticket = @soap_client.OpenConnectionAndBeginSession(@user, @password, '', @application_name, '', @mode)
      return @ticket
    end
    
    # Send a raw (unprocessed) QBXML message to QuickBooks RDS Server
    def send_raw(xml)
      open
      @soap_client.ProcessRequest(@ticket, xml)
      close     
    end
    
    # Send a specific message to server, however it is wrapped with
    # correct xml instruction and QBXML Version.
    def send(xml)
      msg = <<EOL
<?xml version="1.0"?>
<?qbxml version="#{QBXML_VERSION}"?>
<QBXML>
  <QBXMLMsgsRq onError="continueOnError">
    #{xml}</QBXMLMsgsRq>
</QBXML>
EOL
      puts msg
      @soap_client.ProcessRequest(@ticket, xml)
    end
    
    # Close the session to QuickBooks RDS Server
    def close
      if connected? && @soap_client
        @soap_client.CloseConnection(@ticket)
        @soap_client = nil
        @ticket = nil
      end        
    end
    
  end
end
