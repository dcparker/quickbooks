require 'quickbooks/models/common/all_refs'
require 'quickbooks/models/common/address'

module Quickbooks
  class Vendor < ListItem
    self.valid_filters = ['active_status', 'from_modified_date', 'to_modified_date', 'name_filter', 'name_range_filter', 'total_balance_filter']

    # Properties are in the order required by QBXML
    read_write  :name,
                :is_active,
                ParentRef,
                :company_name,
                :salutation,
                :first_name,
                :middle_name,
                :last_name,
                VendorAddress,
                :phone,
                :alt_phone,
                :fax,
                :email,
                :contact,
                :alt_contact,
                VendorTypeRef,
                TermsRef,
                :credit_limit,
                :vendor_tax_indent,
                :is_vendor_eligible_for_1099,
                :open_balance,
                :open_balance_date,
                BillingRateRef
  end
end
