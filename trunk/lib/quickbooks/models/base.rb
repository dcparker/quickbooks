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

module QuickBooks
  module Models
    class Base
      def add_xml
        xml 
      end
      
      def mod_xml
      end
           
    end
    
    class Transaction
      attr_accessor :id, :ref_number
      
      def self.delete
      end
      
      def delete
      end
      
      def self.void
      end
      
      def void
      end
      
    end
    
    class ListItem < Base
      attr_accessor :id, :full_name
      
      def self.delete(id)
      end
      
      def delete
      end  
    end
    
    class DataExt < Base
      attr_accessor :owner_id, :data_ext_name, :data_ext_type, :data_ext_value   
    end
    
    class CreditCardInfo
      attr_accessor :credit_card_number, :expiration_month, :expiration_year, :name_on_card, :credit_card_address, :credit_card_postal_code
    end
    
    class Address
      attr_accessor :addr1, :addr2, :addr3, :addr4, :city, :state, :postal_code, :country    
    end
    
    
  end
end