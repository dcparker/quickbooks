require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class ItemRef < Ref
    properties ListID, FullName
  end
end

# <ItemRef>                                         <!-- opt -->
#   <ListID>IDTYPE</ListID>                         <!-- opt -->
#   <FullName>STRTYPE</FullName>                    <!-- opt -->
# </ItemRef>
