require 'quickbooks/embedded_entity'
require 'quickbooks/properties/txn_line_id'
require 'quickbooks/refs/item_ref'
require 'quickbooks/properties/desc'
require 'quickbooks/properties/quantity'
require 'quickbooks/properties/unit_of_measure'
require 'quickbooks/properties/rate'
require 'quickbooks/properties/rate_percent'
require 'quickbooks/refs/price_level_ref'
require 'quickbooks/refs/class_ref'
require 'quickbooks/properties/amount'
require 'quickbooks/refs/sales_tax_code_ref'
require 'quickbooks/properties/is_manually_closed'
require 'quickbooks/properties/other'
require 'quickbooks/entities/data_ext'
module Quickbooks
  class SalesOrderLine < EmbeddedEntity
    properties TxnLineID,
               ItemRef,
               Desc[:max_length => {4095 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               Quantity,
               UnitOfMeasure[:max_length => {31 => [:QBD, :QBCA, :QBUK, :QBAU, 7.0]}],
               Rate,
               RatePercent,
               PriceLevelRef[:only_in => 4.0],
               ClassRef,
               Amount,
               SalesTaxCodeRef,
               IsManuallyClosed,
               Other1[:max_length => {29 => [:QBD, :QBCA, :QBUK, :QBAU, 6.0]}],
               Other2[:max_length => {29 => [:QBD, :QBCA, :QBUK, :QBAU, 6.0]}] #, DataExts[:only_in => 5.0]
  end

  class SalesOrderLines < EmbeddedEntities
    set_singular_class SalesOrderLine
  end
end

# <SalesOrderLineAdd>
#   <ItemRef>                                         <!-- opt -->
#     <ListID>IDTYPE</ListID>                         <!-- opt -->
#     <FullName>STRTYPE</FullName>                    <!-- opt -->
#   </ItemRef>
#   <Desc>STRTYPE</Desc>                              <!-- opt, max length = 4095 for QBD|QBCA|QBUK|QBAU -->
#   <Quantity>QUANTYPE</Quantity>                     <!-- opt -->
#   <UnitOfMeasure>STRTYPE</UnitOfMeasure>            <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, v7.0 -->
#   <!-- BEGIN OR: You may optionally have Rate OR RatePercent OR PriceLevelRef -->
#   <Rate>PRICETYPE</Rate>
#   <!-- OR -->
#   <RatePercent>PERCENTTYPE</RatePercent>
#   <!-- OR -->
#   <PriceLevelRef>                                   <!-- v4.0 -->
#     <ListID>IDTYPE</ListID>                         <!-- opt -->
#     <FullName>STRTYPE</FullName>                    <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
#   </PriceLevelRef>
#   <!-- END OR -->
#   <ClassRef>                                        <!-- opt -->
#     <ListID>IDTYPE</ListID>                         <!-- opt -->
#     <FullName>STRTYPE</FullName>                    <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
#   </ClassRef>
#   <Amount>AMTTYPE</Amount>                          <!-- opt -->
#   <SalesTaxCodeRef>                                 <!-- opt -->
#     <ListID>IDTYPE</ListID>                         <!-- opt -->
#     <FullName>STRTYPE</FullName>                    <!-- opt, max length = 3 for QBD|QBCA|QBUK, max length = 6 for QBAU -->
#   </SalesTaxCodeRef>
#   <IsManuallyClosed>BOOLTYPE</IsManuallyClosed>     <!-- opt -->
#   <Other1>STRTYPE</Other1>                          <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
#   <Other2>STRTYPE</Other2>                          <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
#   <DataExt>                                         <!-- opt, may rep, v5.0 -->
#     <OwnerID>GUIDTYPE</OwnerID>
#     <DataExtName>STRTYPE</DataExtName>              <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
#     <DataExtValue>STRTYPE</DataExtValue>
#   </DataExt>
# </SalesOrderLineAdd>
