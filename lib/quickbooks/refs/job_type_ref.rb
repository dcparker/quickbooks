require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class JobTypeRef < Ref
    properties ListID,
               FullName[:max_length => {159 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <JobTypeRef>                                        <!-- opt, not in QBOE -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
# </JobTypeRef>
