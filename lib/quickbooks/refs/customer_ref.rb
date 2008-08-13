require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class CustomerRef < Ref
    properties ListID[:writable => true],
               FullName[:max_length => {209 => [:QBD, :QBCA, :QBUK, :QBAU]}]

    def self.reader_name
      @reader_name ||= 'customer'
    end
    def self.writer_name
      @writer_name ||= 'customer='
    end
  end
end

# <CustomerRef>
#   <ListID>IDTYPE</ListID>                           <!-- opt -->
#   <FullName>STRTYPE</FullName>                      <!-- opt, max length = 209 for QBD|QBCA|QBUK|QBAU -->
# </CustomerRef>
