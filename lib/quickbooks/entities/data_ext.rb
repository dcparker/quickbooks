require 'quickbooks/properties/owner_id'
require 'quickbooks/properties/data_ext_name'
require 'quickbooks/properties/data_ext_type'
require 'quickbooks/properties/data_ext_value'
module Quickbooks
  class DataExts < EntityCollection
  end

  # Inherits from Base because it is managed separately from the models it is displayed as a part of.
  class DataExt < Base
    properties OwnerID,
               DataExtName[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               DataExtType,
               DataExtValue
  end
end

# <DataExtRet>                                        <!-- opt, may rep, not in QBOE, v2.0 -->
#   <OwnerID>GUIDTYPE</OwnerID>                       <!-- opt -->
#   <DataExtName>STRTYPE</DataExtName>                <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
#   <!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
#   <DataExtType>ENUMTYPE</DataExtType>
#   <DataExtValue>STRTYPE</DataExtValue>
# </DataExtRet>
