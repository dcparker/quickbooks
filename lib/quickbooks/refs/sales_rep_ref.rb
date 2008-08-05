require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class SalesRepRef < Ref
    properties ListID,
               FullName[:max_length => {5 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <SalesRepRef>                                       <!-- opt, not in QBOE -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 5 for QBD|QBCA|QBUK|QBAU -->
# </SalesRepRef>
