require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class PriceLevelRef < Ref
    properties ListID,
               FullName[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <PriceLevelRef>                                     <!-- opt, not in QBOE, v4.0 -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
# </PriceLevelRef>
