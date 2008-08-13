require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
module Quickbooks
  class ItemRef < Ref
    properties ListID, FullName

    def self.reader_name
      @reader_name ||= 'item'
    end
    def self.writer_name
      @writer_name ||= 'item='
    end
  end
end

# <ItemRef>                                         <!-- opt -->
#   <ListID>IDTYPE</ListID>                         <!-- opt -->
#   <FullName>STRTYPE</FullName>                    <!-- opt -->
# </ItemRef>
