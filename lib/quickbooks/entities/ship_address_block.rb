require 'quickbooks/properties/addr'
module Quickbooks
  class ShipAddressBlock < Entity
    properties Addr1[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               Addr2[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               Addr3[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               Addr4[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               Addr5[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <ShipAddressBlock>                                  <!-- opt, v6.0 -->
#   <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#   <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#   <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#   <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#   <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
# </ShipAddressBlock>
