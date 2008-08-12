require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class ShipMethodRef < Ref
    properties ListID,
               FullName[:max_length => {15 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <ShipMethodRef>                                     <!-- opt -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 15 for QBD|QBCA|QBUK|QBAU -->
# </ShipMethodRef>
