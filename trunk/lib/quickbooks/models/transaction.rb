class Quickbooks::Transaction < Quickbooks::Base
  # attr_accessor :id, :ref_number
  attr_accessor :list_id, :full_name, :edit_sequence, :time_created, :time_modified, :is_active

  # Currently, the following transaction types can be modified: 
  # • Bill
  # • BillPaymentCheck
  # • BuildAssembly
  # • Charge
  # • Check
  # • CreditCardCharge
  # • CreditCardCredit
  # • CreditMemo
  # • Deposit
  # • Estimate
  # • Invoice
  # • JournalEntry
  # • ItemReceipt
  # • PriceLevel
  # • PurchaseOrder
  # • ReceivePayment
  # • SalesOrder
  # • SalesReceipt
  # • StatementCharge
  # • TimeTracking

  class << self
    def child_types
      [ "Bill", "BillPaymentCheck", "BillPaymentCreditCard",
        "BuildAssembly", "Charge", "Check", "CreditCardCharge",
        "CreditCardCredit", "CreditCardRefund", "CreditMemo",
        "Deposit", "Estimate", "InventoryAdjustment",
        "Invoice", "ItemReceipt", "JournalEntry",
        "PurchaseOrder", "ReceivePayment", "SalesOrder",
        "SalesReceipt", "SalesTaxPaymentCheck", "TimeTracking",
        "VehicleMileage", "VendorCredit"
      ]
    end
  end
end
