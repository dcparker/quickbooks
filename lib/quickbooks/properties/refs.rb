module Quickbooks
  # A reference simply is a link to another object. These are mostly included in other models as attributes.
  class Ref < Entity
    # Here goes the connector code for a Ref's association calls
  end

  [ "CustomerMsg",
    "CustomerSalesTaxCode", "Item", "ItemSalesTax",
    "OverrideItemAccount", "PriceLevel", "SalesRep",
    "SalesTaxCode", "ShipMethod", "Terms"
  ].each do |ref_klass|
    eval "
      class #{ref_klass}Ref < Ref
        properties  ListID,
                    FullName
      end"
  end
end
