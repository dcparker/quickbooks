class Quickbooks::ListItem < Quickbooks::Base

  self.valid_filters = [:list_id, :full_name]
  self.filter_aliases = {:modified_after => :from_modified_date, :modified_before => :to_modified_date}

  def self.inherited(klass)
    super
    klass.read_only :list_id, :full_name, :edit_sequence, :time_created, :time_modified
  end

  class << self
    def ListOrTxn
      'List'
    end

    # def child_types
    #   [ "Account", "Account List", "BillingRate",
    #     "Class", "Currency", "Customer",
    #     "CustomerMessage", "CustomerType",
    #     "DateDrivenTerms", "Employee", "ItemDiscount",
    #     "ItemFixedAsset", "ItemGroup", "ItemInventory",
    #     "ItemInventoryAssembly", "ItemNonInventory",
    #     "ItemOtherCharge", "ItemPayment", "ItemSalesTax",
    #     "ItemSalesTaxGroup", "ItemService", "ItemSubtotal",
    #     "JobType", "OtherName", "PaymentMethod",
    #     "PayrollItemNonWage", "PayrollItemWage", "PriceLevel",
    #     "SalesRep", "SalesTaxCode", "ShipMethod",
    #     "StandardTerms", "TaxCode", "Template", "ToDo",
    #     "Vehicle", "Vendor", "VendorType"
    #   ]
    # end
  end
end
