require 'quickbooks/properties/addr'
require 'quickbooks/properties/city'
require 'quickbooks/properties/state'
require 'quickbooks/properties/postal_code'
require 'quickbooks/properties/country'
require 'quickbooks/properties/note'
module Quickbooks
  class Address < Entity
    properties Addr1,
               Addr2[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU], 500 => :QBOE}],
               Addr3[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU], 500 => :QBOE}],
               Addr4[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU], 500 => [:QBOE, 2.0]}],
               Addr5[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => [:QBOE, 6.0]],
               City[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU], 255 => :QBOE}],
               State[:max_length => {21 => [:QBD, :QBCA, :QBUK, :QBAU], 255 => :QBOE}],
               PostalCode[:max_length => {13 => [:QBD, :QBCA, :QBUK, :QBAU], 30 => :QBOE}],
               Country[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU], 255 => :QBOE}],
               Note[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => [:QBOE, 6.0]]
  end
end

# <BillAddress>                                       <!-- opt -->
#   <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#   <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#   <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#   <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE, v2.0 -->
#   <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
#   <City>STRTYPE</City>                              <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#   <State>STRTYPE</State>                            <!-- opt, max length = 21 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#   <PostalCode>STRTYPE</PostalCode>                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU, max length = 30 for QBOE -->
#   <Country>STRTYPE</Country>                        <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#   <Note>STRTYPE</Note>                              <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
# </BillAddress>
# <ShipAddress>                                       <!-- opt -->
#   <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#   <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#   <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#   <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE, v2.0 -->
#   <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
#   <City>STRTYPE</City>                              <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#   <State>STRTYPE</State>                            <!-- opt, max length = 21 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#   <PostalCode>STRTYPE</PostalCode>                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU, max length = 30 for QBOE -->
#   <Country>STRTYPE</Country>                        <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#   <Note>STRTYPE</Note>                              <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
# </ShipAddress>
