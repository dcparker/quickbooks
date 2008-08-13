module Quickbooks
  class TxnType < EnumProperty
    enum 'ARRefundCreditCard', 'Bill', 'BillPaymentCheck', 'BillPaymentCreditCard', 'BuildAssembly', 'Charge', 'Check', 'CreditCardCharge', 'CreditCardCredit', 'CreditMemo', 'Deposit', 'Estimate', 'InventoryAdjustment', 'Invoice', 'ItemReceipt', 'JournalEntry', 'LiabilityAdjustment', 'Paycheck', 'PayrollLiabilityCheck', 'PurchaseOrder', 'ReceivePayment', 'SalesOrder', 'SalesReceipt', 'SalesTaxPaymentCheck', 'Transfer', 'VendorCredit', 'YTDAdjustment'
  end
end

#   <!-- TxnType may have one of the following values: ARRefundCreditCard, Bill, BillPaymentCheck, BillPaymentCreditCard, BuildAssembly, Charge, Check, CreditCardCharge, CreditCardCredit, CreditMemo, Deposit, Estimate, InventoryAdjustment, Invoice, ItemReceipt, JournalEntry, LiabilityAdjustment, Paycheck, PayrollLiabilityCheck, PurchaseOrder, ReceivePayment, SalesOrder, SalesReceipt, SalesTaxPaymentCheck, Transfer, VendorCredit, YTDAdjustment -->
#   <TxnType>ENUMTYPE</TxnType>
