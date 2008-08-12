require 'quickbooks/embedded_entity'
require 'quickbooks/properties/txn_line_id'
module Quickbooks
  class TransactionLines < EmbeddedEntities
  end
  class TransactionLine < EmbeddedEntity
  end
end