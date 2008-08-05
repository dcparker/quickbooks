require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class TermsRef < Ref
    properties ListID,
               FullName[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU], 100 => :QBOE}]
  end
end

# <TermsRef>                                          <!-- opt -->
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 100 for QBOE -->
# </TermsRef>
