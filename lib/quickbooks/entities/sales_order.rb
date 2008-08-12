require 'quickbooks/refs/customer_ref'
require 'quickbooks/refs/class_ref'
require 'quickbooks/refs/template_ref'
require 'quickbooks/properties/txn_date'
require 'quickbooks/properties/ref_number'
require 'quickbooks/entities/bill_address'
require 'quickbooks/entities/ship_address'
require 'quickbooks/properties/po_number'
require 'quickbooks/refs/terms_ref'
require 'quickbooks/properties/due_date'
require 'quickbooks/refs/sales_rep_ref'
require 'quickbooks/properties/fob'
require 'quickbooks/properties/ship_date'
require 'quickbooks/properties/subtotal'
require 'quickbooks/refs/ship_method_ref'
require 'quickbooks/refs/item_sales_tax_ref'
require 'quickbooks/properties/is_manually_closed'
require 'quickbooks/properties/memo'
require 'quickbooks/refs/customer_msg_ref'
require 'quickbooks/properties/is_to_be_printed'
require 'quickbooks/properties/is_to_be_emailed'
require 'quickbooks/properties/is_tax_included'
require 'quickbooks/refs/customer_sales_tax_code_ref'
require 'quickbooks/properties/other'
require 'quickbooks/embedded_entities/sales_order_lines'
module Quickbooks
  class SalesOrder < Transaction
    self.valid_filters = ['entity_filter', 'from_modified_date', 'to_modified_date']

    properties CustomerRef[:required => true],
               ClassRef,
               TemplateRef[:only_in => 3.0],
               TxnDate,
               RefNumber[:max_length => {11 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               BillAddress,
               ShipAddress,
               PONumber[:max_length => {25 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               TermsRef,
               DueDate,
               SalesRepRef,
               FOB[:max_length => {13 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               ShipDate,
               Subtotal[:read_only => true],
               SalesTaxPercentage[:read_only => true],
               SalesTaxTotal[:read_only => true],
               ShipMethodRef,
               ItemSalesTaxRef,
               IsManuallyClosed,
               Memo[:max_length => {4095 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               CustomerMsgRef,
               IsToBePrinted,
               IsToBeEmailed[:not_in => [:QBD, 6.0]],
               IsTaxIncluded[:not_in => [:QBD, 6.0]],
               CustomerSalesTaxCodeRef,
               Other[:max_length => {29 => [:QBD, :QBCA, :QBUK, :QBAU, 6.0]}],
               SalesOrderLines[:minimum => 1]
  end
end

# <!-- BEGIN OR: You may have 1 or more SalesOrderLineAdd OR SalesOrderLineGroupAdd -->
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
# <!-- OR -->
# <SalesOrderLineGroupAdd>
#   <ItemGroupRef>
#     <ListID>IDTYPE</ListID>                         <!-- opt -->
#     <FullName>STRTYPE</FullName>                    <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
#   </ItemGroupRef>
#   <Desc>STRTYPE</Desc>                              <!-- opt, not in QBD|QBCA|QBUK|QBAU -->
#   <Quantity>QUANTYPE</Quantity>                     <!-- opt -->
#   <UnitOfMeasure>STRTYPE</UnitOfMeasure>            <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, v7.0 -->
#   <DataExt>                                         <!-- opt, may rep, v5.0 -->
#     <OwnerID>GUIDTYPE</OwnerID>
#     <DataExtName>STRTYPE</DataExtName>              <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
#     <DataExtValue>STRTYPE</DataExtValue>
#   </DataExt>
# </SalesOrderLineGroupAdd>
# <!-- END OR -->
