require File.dirname(__FILE__) + '/base'
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
      
      def initialize()
        @new_record = true
        
        @parent_ref = ListItem.new
        @bill_address = Address.new        
        @terms_ref = ListItem.new
        @sales_rep_ref = ListItem.new
        @sales_tax_code_ref = ListItem.new
        @item_sales_tax_ref = ListItem.new
        @preferred_payment_method_ref = ListItem.new
        @job_type_ref = ListItem.new
        @price_live_ref = ListItem.new
        @data_ext_ref = ListItem.new
        
        @ship_address = Address.new
        @customer_type_ref = ListItem.new
        
        @credit_card_info = CreditCardInfo.new
      end                    
      
      def new_record?
        @new_record
      end
      
      def self.find(full_name)
        xml = <<EOL
<?xml version="1.0"?>
<?qbxml version="3.0"?>
<QBXML>
  <QBXMLMsgsRq onError="continueOnError">
    <CustomerQueryReq>
      <FullName>#{full_name}</FullName>
    </CustomerQueryReq>
  </QBXMLMsgsRq>
</QBXML>
EOL
        @@connection.send_raw(xml)
      end
     
      
    end
  end
end