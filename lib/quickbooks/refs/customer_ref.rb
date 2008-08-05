require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class CustomerRef < Ref
    properties ListID,
               FullName[:max_length => {209 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <CustomerRef>
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 209 for QBD|QBCA|QBUK|QBAU -->
# </CustomerRef>
