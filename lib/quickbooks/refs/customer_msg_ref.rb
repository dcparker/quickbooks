require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class CustomerMsgRef < Ref
    properties ListID,
               FullName[:max_length => {101 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <CustomerMsgRef>                                    <!-- opt -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 101 for QBD|QBCA|QBUK|QBAU -->
# </CustomerMsgRef>
