require 'quickbooks/properties/txn_line_id'
require 'quickbooks/properties/amount'
module Quickbooks
  class TxnLineDetails < EntityCollection
  end

  class TxnLineDetail < Entity
    properties TxnLineID, Amount
  end
end

#   <TxnLineDetail>                                   <!-- opt, may rep, not in QBD|QBCA|QBUK|QBAU -->
#     <TxnLineID>IDTYPE</TxnLineID>
#     <Amount>AMTTYPE</Amount>
#   </TxnLineDetail>
