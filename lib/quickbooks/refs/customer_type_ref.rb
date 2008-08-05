require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class CustomerTypeRef < Ref
    properties ListID,
               FullName[:max_length => {159 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <CustomerTypeRef>                                   <!-- opt, not in QBOE -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
# </CustomerTypeRef>
