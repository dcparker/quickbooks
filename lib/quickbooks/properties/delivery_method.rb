module Quickbooks
  class DeliveryMethod < EnumProperty
    enum 'Email', 'Fax', 'Print'
  end
end
