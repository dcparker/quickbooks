class Quickbooks::ListItem < Quickbooks::Base
  attr_accessor :list_id, :full_name, :edit_sequence, :time_created, :time_modified, :is_active

  class << self
    def child_types
      [ "Account", "Account List", "BillingRate",
        "Class", "Currency", "Customer",
        "CustomerMessage", "CustomerType",
        "DateDrivenTerms", "Employee", "ItemDiscount",
        "ItemFixedAsset", "ItemGroup", "ItemInventory",
        "ItemInventoryAssembly", "ItemNonInventory",
        "ItemOtherCharge", "ItemPayment", "ItemSalesTax",
        "ItemSalesTaxGroup", "ItemService", "ItemSubtotal",
        "JobType", "OtherName", "PaymentMethod",
        "PayrollItemNonWage", "PayrollItemWage", "PriceLevel",
        "SalesRep", "SalesTaxCode", "ShipMethod",
        "StandardTerms", "TaxCode", "Template", "ToDo",
        "Vehicle", "Vendor", "VendorType"
      ]
    end
  end
end
