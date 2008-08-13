require 'quickbooks/properties/txn_id'
require 'quickbooks/properties/txn_type'
require 'quickbooks/properties/txn_date'
require 'quickbooks/properties/ref_number'
require 'quickbooks/properties/link_type'
require 'quickbooks/properties/amount'
require 'quickbooks/embedded_entities/txn_line_details'
module Quickbooks
  class LinkedTxns < EntityCollection
  end

  class LinkedTxn < Entity
    properties TxnID,
               TxnType,
               TxnDate,
               RefNumber[:max_length => {20 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               LinkType[:only_in => 3.0],
               Amount,
               TxnLineDetails[:not_in => [:QBD, :QBCA, :QBUK, :QBAU]]
  end
end

# <LinkedTxn>                                         <!-- opt, may rep -->
#   <TxnID>IDTYPE</TxnID>
#   <!-- TxnType may have one of the following values: ARRefundCreditCard, Bill, BillPaymentCheck, BillPaymentCreditCard, BuildAssembly, Charge, Check, CreditCardCharge, CreditCardCredit, CreditMemo, Deposit, Estimate, InventoryAdjustment, Invoice, ItemReceipt, JournalEntry, LiabilityAdjustment, Paycheck, PayrollLiabilityCheck, PurchaseOrder, ReceivePayment, SalesOrder, SalesReceipt, SalesTaxPaymentCheck, Transfer, VendorCredit, YTDAdjustment -->
#   <TxnType>ENUMTYPE</TxnType>
#   <TxnDate>DATETYPE</TxnDate>
#   <RefNumber>STRTYPE</RefNumber>                    <!-- opt, max length = 20 for QBD|QBCA|QBUK|QBAU -->
#   <!-- LinkType may have one of the following values: AMTTYPE, QUANTYPE -->
#   <LinkType>ENUMTYPE</LinkType>                     <!-- opt, v3.0 -->
#   <Amount>AMTTYPE</Amount>
#   <TxnLineDetail>                                   <!-- opt, may rep, not in QBD|QBCA|QBUK|QBAU -->
#     <TxnLineID>IDTYPE</TxnLineID>
#     <Amount>AMTTYPE</Amount>
#   </TxnLineDetail>
# </LinkedTxn>
