module Quickbooks
  # A reference simply is a link to another object. These are mostly included in other models as attributes.
  class Ref < Model
    def self.inherited(klass)
      klass.read_only :list_id, :full_name
    end

    # Put in here the connector code for 'association' calls
  end
  
  class ParentRef < Ref
  end
  
  class CustomerTypeRef < Ref
  end
  
  class TermsRef < Ref
  end
  
  class SalesRepRef < Ref
  end
  
  class SalesTaxCodeRef < Ref
  end
  
  class ItemSalesTaxRef < Ref
  end
  
  class PreferredPaymentMethodRef < Ref
  end
  
  class JobTypeRef < Ref
  end
  
  class PriceLevelRef < Ref
  end
end
