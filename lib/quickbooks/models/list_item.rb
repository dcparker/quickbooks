module Quickbooks
  # A ListItem is identified in quickbooks by ListID. All ListItems also have a unique FullName, so if you know
  # what the FullName of a ListItem is, you can find it that way. Always use the underscore version of finders, such as:
  #   Quickbooks::Customer.first(:list_id => '12345-6789-09876543')
  #   Quickbooks::Deleted.all(:list_del_type => 'Customer', :deleted_after => Time.now - 24*60*60)
  # (See Deleted for specifics on those options.)
  class ListItem < Base

    self.valid_filters = ['list_id', 'full_name']
    self.filter_aliases = {'updated_after' => 'from_modified_date', 'updated_before' => 'to_modified_date'}

    def self.inherited(klass)
      super
      # :time_deleted only comes from ListDeleted, but that way all ListDeleted attributes can be instantiated into their respective ListItem model
      klass.read_only :list_id, :full_name, :edit_sequence, :time_created, :time_modified, :time_deleted
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
end
