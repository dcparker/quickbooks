require 'quickbooks/properties/txn_id'
require 'quickbooks/properties/full_name'
require 'quickbooks/properties/edit_sequence'
require 'quickbooks/properties/time_created'
require 'quickbooks/properties/time_modified'
module Quickbooks
  class Transaction < Base
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
end