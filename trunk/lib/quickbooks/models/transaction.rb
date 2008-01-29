class Quickbooks::Transaction < Quickbooks::Base

  self.valid_filters = [:txn_id]

  def self.inherited(klass)
    super
    klass.read_only :txn_id, :full_name, :edit_sequence, :time_created, :time_modified
  end

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
    def ListOrTxn
      'Txn'
    end

    # def child_types
    #   [ "Bill", "BillPaymentCheck", "BillPaymentCreditCard",
    #     "BuildAssembly", "Charge", "Check", "CreditCardCharge",
    #     "CreditCardCredit", "CreditCardRefund", "CreditMemo",
    #     "Deposit", "Estimate", "InventoryAdjustment",
    #     "Invoice", "ItemReceipt", "JournalEntry",
    #     "PurchaseOrder", "ReceivePayment", "SalesOrder",
    #     "SalesReceipt", "SalesTaxPaymentCheck", "TimeTracking",
    #     "VehicleMileage", "VendorCredit"
    #   ]
    # end
  end
end
