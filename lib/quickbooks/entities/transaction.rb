class Quickbooks::Transaction < Quickbooks::Base
  self.valid_filters = ['txn_id', 'ref_number', 'ref_number_case_sensitive']

  def self.inherited(base)
    super
    base.properties TxnID, FullName, EditSequence, TimeCreated, TimeModified
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
  end
end
