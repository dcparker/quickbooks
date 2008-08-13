module Quickbooks
  class OverrideUOMSetRef < Ref
    properties ListID,
               FullName[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU]}]
  end
end

# <OverrideUOMSetRef>                               <!-- opt, v7.0 -->
#   <ListID>IDTYPE</ListID>                         <!-- opt -->
#   <FullName>STRTYPE</FullName>                    <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
# </OverrideUOMSetRef>
