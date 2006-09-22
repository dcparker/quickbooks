module XmlHelper
  def to_xml
    xml = String.new
    b = Builder::XmlMarkup.new :target => xml
    instance_variables.each do |name|
      v = instance_variable_get(name)
      if v.respond_to?("to_xml")
        xml << v.to_xml
      else
        b.tag!(name[1..-1], v)
      end
    end
    xml
  end
end

module QuickBooks
  module Models
    class Base
      include XmlHelper
      
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
      
      def mod_xml
      end
      
    end
    
    class Transaction < Base
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
      def initialize
        @owner_id = ""
        @data_ext_name = ""
        @data_ext_type = ""
        @data_ext_value = ""
      end 
    end
    
    class CreditCardInfo
      include XmlHelper
      attr_accessor :credit_card_number, :expiration_month, :expiration_year, :name_on_card, :credit_card_address, :credit_card_postal_code
      def initialize
        @credit_card_numer = ""
        @expiration_month = ""
        @expiration_year = ""
        @name_on_card = ""
        @credit_card_address = ""
        @credit_card_postal_code = ""
      end
    end
    
    class Address
      include XmlHelper
      attr_accessor :addr1, :addr2, :addr3, :addr4, :city, :state, :postal_code, :country   
      def initialize
        @addr1 = ""
        @addr2 = ""
        @addr3 = ""
        @addr4 = ""
        @city = ""
        @state = ""
        @postal_code = ""
        @country = ""
      end 
    end    
  end
end