require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class ParentRef < Ref
    properties ListID,
               FullName
  end
end

# <ParentRef>                                         <!-- opt -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt -->
# </ParentRef>
