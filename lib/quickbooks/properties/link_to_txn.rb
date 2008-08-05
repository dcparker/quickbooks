module Quickbooks
  class LinkToTxnCollection < EntityCollection
  end

  class LinkToTxn < Entity
    properties  TxnID,
                TxnLineID
  end
end
