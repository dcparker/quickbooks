module QuickBooks
  module Models
    class Base
    
      # Establishes a connection to the QuickBooks RDS Server for all Model Classes    
      def self.establish_connection(user, password, application_name, host="localhost", port=3790, mode='multiUser')
        @@connection = Connection.new(user, password, application_name, host, port, mode)
        @@connection.open
      end
      
      # Returns the current Connection
      def self.connection
        @@connection
      end
      
      # Sets the current Connection
      #   connection = QuickBooks::Connection.new('user', 'pass', 'My Test App')
      #   QuickBooks::Models::Base.connection = connection
      def self.connection=(connection)
        @@connection = connection
      end
      
      def add_xml
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