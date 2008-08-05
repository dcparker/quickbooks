require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class ItemSalesTaxRef < Ref
    properties ListID,
               FullName[:max_length => [:QBD, :QBCA, :QBUK, :QBAU]]
  end
end

# <ItemSalesTaxRef>                                   <!-- opt, not in QBOE -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
# </ItemSalesTaxRef>
