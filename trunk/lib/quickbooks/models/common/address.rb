module Quickbooks
  class Address < Model
    def self.inherited(klass)
      super
      klass.read_write :addr1, :addr2, :addr3, :addr4, :addr5, :city, :state, :postal_code, :country, :note
    end
  end

  class BillAddress < Address
  end

  class ShipAddress < Address
  end
end
