#-- 
# Copyright (c) 2006 Chris Bruce
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial 
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
# OR OTHER DEALINGS IN THE SOFTWARE.
#++
# QuickBooks::Session is used to communicate with QuickBooks RDS Server.  You need to configure
# your QuickBooks software to allow RDS connection from application.
# 
#   require 'quickbooks'
#   
#   session = QuickBooks::Session.new('admin', 'pass', 'My Test App')
#   session.open
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
#   session.send(xml)
#   session.close 
require 'quickbooks/session'
