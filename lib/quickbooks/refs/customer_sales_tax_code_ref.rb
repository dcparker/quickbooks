require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class CustomerSalesTaxCodeRef < Ref
    properties ListID,
               FullName[:max_length => {3 => [:QBD, :QBCA, :QBUK], 6 => :QBAU}]
  end
end

# <CustomerSalesTaxCodeRef>                           <!-- opt -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 3 for QBD|QBCA|QBUK, max length = 6 for QBAU -->
# </CustomerSalesTaxCodeRef>
