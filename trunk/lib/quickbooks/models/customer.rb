module Quickbooks
  class Customer < ListItem
    properties  :parent_ref,
                :sublevel,

                :name,
                :salutation,
                :first_name,
                :middle_name,
                :last_name,
                :suffix,
                :company_name,

                :phone,
                :mobile,
                :alt_phone,
                :pager,
                :fax,
                :email,
                :contact,
                :alt_contact,
                :bill_address,
                :ship_address,

                :notes,

                :account_number,
                :credit_card_info,
                :credit_limit,
                :balance,
                :open_balance,
                :open_balance_date,
                :total_balance,
                :preferred_payment_method_ref,

                :job_status,
                :job_start_date,
                :job_projected_end_date,
                :job_end_date,
                :job_desc,
                :job_type_ref,

                :print_as,
                :customer_type_ref,
                :delivery_method,
                :price_level_ref,
                :terms_ref,
                :sales_rep_ref,
                :sales_tax_code_ref,
                :item_sales_tax_ref,
                :resale_nmber,
                :is_statement_with_parent,
                :data_ext_ref

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
