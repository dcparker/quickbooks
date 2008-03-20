require 'quickbooks/models/common/all_refs'
require 'quickbooks/models/common/address'
require 'quickbooks/models/customer/credit_card_info'

module Quickbooks
  class Customer < ListItem
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
                :suffix,
                BillAddress,
                ShipAddress,
                :print_as,
                :phone,
                # :mobile, # only in QBOE
                :pager,
                :alt_phone,
                :fax,
                :email,
                :contact,
                :alt_contact,
                CustomerTypeRef,
                TermsRef,
                SalesRepRef,
                # :open_balance,
                # :open_balance_date,
                SalesTaxCodeRef,
                ItemSalesTaxRef,
                :sales_tax_country,
                :resale_nmber,
                :account_number,
                :credit_limit,
                PreferredPaymentMethodRef,
                CreditCardInfo,
                :job_status,
                :job_start_date,
                :job_projected_end_date,
                :job_end_date,
                :job_desc,
                JobTypeRef,
                :notes,
                :is_statement_with_parent,
                :delivery_method,
                PriceLevelRef

    # def initialize
    #   @parent_ref = ListItem.new
    #   @bill_address = Address.new
    #   @terms_ref = ListItem.new
    #   @sales_rep_ref = ListItem.new
    #   @sales_tax_code_ref = ListItem.new
    #   @item_sales_tax_ref = ListItem.new
    #   @preferred_payment_method_ref = ListItem.new
    #   @job_type_ref = ListItem.new
    #   @price_live_ref = ListItem.new
    #   @data_ext_ref = ListItem.new
    #   @ship_address = Address.new
    #   @customer_type_ref = ListItem.new
    #   @credit_card_info = CreditCardInfo.new
    # end
  end
end
