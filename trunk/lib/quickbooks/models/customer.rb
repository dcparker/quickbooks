# Copyright (c) 2006 Chris Bruce
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial 
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
# OR OTHER DEALINGS IN THE SOFTWARE.

require 'base'
module QuickBooks
  module Models
    class Customer < ListItem
      attr_accessor(:time_created, :time_modified, :edit_sequence, :name, :is_active, :parent_ref, :sublevel,
                    :company_name, :salutation, :first_name, :middle_name, :last_name, :suffix, :bill_address, :ship_address,
                    :print_as, :phone, :mobile, :pager, :alt_phone, :fax, :email, :contact, :alt_contact, :customer_type_ref,
                    :terms_ref, :sales_rep_ref, :open_balance, :open_balance_date, :balance, :total_balance, :sales_tax_code_ref,
                    :item_sales_tax_ref, :resale_nmber, :account_number, :credit_limit, :preferred_payment_method_ref,
                    :credit_card_info, :job_status, :job_start_date, :job_projected_end_date, :job_end_date, :job_desc,
                    :job_type_ref, :notes, :is_statement_with_parent, :delivery_method, :price_level_ref, :data_ext_ref)
      
      def initialize(attributes={})
        @new_record = true
        
        @parent_ref = new ListItem
        @bill_address = new Address        
        @terms_ref = new ListItem
        @sales_rep_ref = new ListItem
        @sales_tax_code_ref = new ListItem
        @item_sales_tax_ref = new ListItem
        @preferred_payment_method_ref = new ListItem
        @job_type_ref = new ListItem
        @price_live_ref = new ListItem
        @data_ext_ref = new ListItem
        
        @ship_address = new Address
        @customer_type_ref = new ListItem
        
        @credit_card_info = new CreditCardInfo
      end                    
      
      def new_record?
      end
      
      
    end
  end
end