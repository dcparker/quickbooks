# Contains Quickbooks::Base. Two models inherit directly from Quickbooks::Base: ListItem and Transaction.
# All other models inherit from one of these.
# 
# Inheriting from ListItem:
# - Account
# - Account List
# - BillingRate
# - Class
# - Currency
# - Customer
# - CustomerMessage
# - CustomerType
# - DateDrivenTerms
# - Employee
# - ItemDiscount
# - ItemFixedAsset
# - ItemGroup
# - ItemInventory
# - ItemInventoryAssembly
# - ItemNonInventory
# - ItemOtherCharge
# - ItemPayment
# - ItemSalesTax
# - ItemSalesTaxGroup
# - ItemService
# - ItemSubtotal
# - JobType
# - OtherName
# - PaymentMethod
# - PayrollItemNonWage
# - PayrollItemWage
# - PriceLevel
# - SalesRep
# - SalesTaxCode
# - ShipMethod
# - StandardTerms
# - TaxCode
# - Template
# - ToDo
# - Vehicle
# - Vendor
# - VendorType
# Inheriting from Transaction:
# - Bill
# - BillPaymentCheck
# - BillPaymentCreditCard
# - BuildAssembly
# - Charge
# - Check
# - CreditCardCharge
# - CreditCardCredit
# - CreditCardRefund
# - CreditMemo
# - Deposit
# - Estimate
# - InventoryAdjustment
# - Invoice
# - ItemReceipt
# - JournalEntry
# - PurchaseOrder
# - ReceivePayment
# - SalesOrder
# - SalesReceipt
# - SalesTaxPaymentCheck
# - TimeTracking
# - VehicleMileage
# - VendorCredit

require 'activesupport'
require 'quickbooks/connection'
require 'quickbooks/qbxml/request'
require 'quickbooks/qbxml/response'

module Quickbooks
  class Base
    # Stores a log of Quickbooks::Qbxml::Response objects that were a result of methods performed on this object.
    attr_accessor :response_log
    def response_log #:nodoc:
      @response_log || (@response_log = [])
    end

    # Returns success (true/false) status of the last quickbooks communication called from this object.
    def success?
      @response_log.last.success?
    end
    def inspect #:nodoc:
      "#<#{self.class.name}:#{self.object_id} #{instance_variables.reject {|i| i.is_one_of?('@response_log', '@original_values')}.map {|i| "#{i}=#{instance_variable_get(i).inspect}"}.join(' ')}>"
    end
    class << self

      # Establishes a connection to the Quickbooks RDS Server for all Model Classes
      def establish_connection(application_name='RubyApplication', file='', user='', password='', connection_type='localQBD', connection_mode='DoNotCare')
        @@connection = Connection.new(application_name, file, user, password, connection_type, connection_mode)
      end

      # Returns the current Connection
      def connection
        @connection || (@@connection ||= self.establish_connection())
      end

      # Sets the current Connection.
      # 
      # This is normally not needed, but in the case that you may want to connect a separate connection to Quickbooks,
      # you can use this method to explicitly set the connection in a class that inherits from Quickbooks::Base.
      #   Quickbooks::Models::Base.connection = Quickbooks::Connection.new('My Test App', 'C:\\Some File.QBW', 'user', 'pass')
      def connection=(conn)
        raise ArgumentError, "Cannot set connection to anything but a Quickbooks::Connection object" unless conn.is_a?(Quickbooks::Connection)
        @connection = conn
      end

      # Register a property in the current class. For example in the Customer class:
      #   property :first_name
      def property(*args)
        raise ArgumentError, "must include a property name" unless args.length > 0
        properties(*args)
      end
      # Register multiple properties at once. For example:
      #   properties :first_name, :last_name, :phone, :alt_phone
      def properties(*args)
        if args.blank?
          @properties || (@properties = [])
        else
          args.each do |property|
            properties << property
            attr_accessor property
          end
        end
      end

      # Generates a request by sending *args to Quickbooks::Qbxml::Request.new, sends the request over the current connection,
      # and interprets the response using Quickbooks::Qbxml::ResponseSet.
      # The response is then instantiated into an object or an array of objects.
      # 
      # This method is used mostly internally, but it is the yoke of this library - use it to perform custom requests.
      def request_and_instantiate(obj_or_args,*args)
        if obj_or_args.is_a?(Quickbooks::Base)
          reinstantiate = obj_or_args
        else
          reinstantiate = nil
          args.unshift(obj_or_args)
        end

        objects = [] # This will hold and return the instantiated objects from the quickbooks response
        self.request(*args).each { |response| objects << response.instantiate(reinstantiate) } # Does not instantiate if it's an error, but simply records response into response_log
        objects.length == 1 ? objects[0] : objects
      end

      # Generates a request using Quickbooks::Qbxml::Request, sends it, and returns a Quickbooks::Qbxml::ResponseSet object containing the response(s).
      def request(*args)
        Qbxml::ResponseSet.new(
          self.connection.send_xml(
            Qbxml::Request.new(*args).to_xml
          )
        )
      end

      # Instantiate a new object with just attributes, or an existing object replacing the attributes
      def instantiate(obj_or_attrs={},attrs={})
        if obj_or_attrs.is_a?(Quickbooks::Base)
          obj = obj_or_attrs
        else
          obj = allocate
          attrs = obj_or_attrs
        end
        attrs.each do |key,value|
          if obj.respond_to?(key.to_s.underscore+'=')
            obj.send(key.to_s.underscore+'=', value)
            obj.original_values[key.to_s.underscore] = value
          end
        end if attrs
        obj # Will be either a nice object, or a Quickbooks::Qbxml::Error object.
      end

      # Queries Quickbooks for all of the objects of the current class's type. For example, Quickbooks::Customer.all will return an array of Quickbooks::Customer objects representing all customers.
      def all(filters={})
        [request_and_instantiate(self.class_leaf_name, :query, filters)].flatten
      end

      # Queries Quickbooks for the first object of the current class's type. For example, Quickbooks::Customer.first will return a Quickbooks::Customer object representing the first customer.
      def first(filters={})
        filters.merge!(:MaxReturned => 1) unless filters.keys.include?(:ListID) || filters.keys.include?(:TxnID) || filters.keys.include?(:FullName)
        request_and_instantiate(self.class_leaf_name, :query, filters)
      end

      # Creates a new object of the current class's type. For example, Quickbooks::Customer.create(:name => 'Tommy') will create a customer object with a Name of Tommy.
      def create(*args)
        new(*args).save
      end
    end

    # The default for all subclasses is simply to apply the attributes given, and mark the object as a new_record?
    def initialize(args={})
      self.attributes = args
      @new_record = true
    end

    # Returns a hash that represents all this object's attributes.
    def attributes
      attrs = {}
      self.class.properties.each do |column|
        attrs[column.to_s] = instance_variable_get('@' + column.to_s)
      end
      attrs
    end
    # Updates all attributes included in _attrs_ to the values given. The object will now be dirty?.
    def attributes=(attrs)
      raise ArgumentError, "attributes can only be set to a hash of attributes" unless attrs.is_a?(Hash)
      attrs.each do |key,value|
        if self.respond_to?(key.to_s.underscore+'=')
          self.send(key.to_s.underscore+'=', value)
        end
      end
    end

    # Keeps track of the original values the object had when it was instantiated from a quickbooks response. dirty? and dirty_attributes compare the current values with these ones.
    def original_values
      @original_values || (@original_values = {})
    end

    # Returns true if any attributes have changed since the object was last loaded or updated from Quickbooks.
    def dirty?
      # Concept: For each column that the current model includes, has the value been changed?
      self.class.properties.any? do |column|
        self.instance_variable_get('@' + column.to_s) != original_values[column.to_s]
      end
    end

    # Returns a hash of the attributes and their (new) values that have been changed since the object was last loaded or updated from Quickbooks.
    def dirty_attributes
      pairs = {}
      self.class.properties.each do |column|
        value = instance_variable_get('@' + column.to_s)
        if value != original_values[column.to_s]
          pairs[column.to_s] = value
        end
      end
      pairs
    end

    # Returns true if the object is a new object (that doesn't represent an existing object in Quickbooks).
    def new_record?
      @new_record
    end

    # Saves the attributes that have changed.
    # 
    # If the EditSequence is out of date but none of the changes conflict, the object will be saved to Quickbooks.
    # But if there are conflicts, the updated values from Quickbooks will be written to the original_values, and false is returned.
    # This way you can deal with the differences (conflicts), if you so desire, and simply call save again to commit your changes.
    def save
      return false unless dirty?
      if new_record?
        self.class.request_and_instantiate(self, self.class.class_leaf_name, :add, dirty_attributes.camelize_keys!)
        @new_record = false if !dirty?
      else
        # Smart system that respects EditSequences and other people's changes.
        # 1) Try to save
        # 2) When we get a status of 3200, that means our EditSequence is not up to date
        # 3) Replace self's original_attributes with those just retrieved, and update the automatic attributes, like EditSequence and TimeModified
        # 4) Return false, return the object dirty but ready to save
        old_originals = original_values.dup
        self.class.request_and_instantiate(self, self.class.class_leaf_name, :mod, dirty_attributes.camelize_keys!.merge(:ListID => self.list_id, :EditSequence => self.edit_sequence))
        # If save failed because of old record, but none of the fields conflict, re-save.
        if dirty? && self.response_log.last.status == 3200
          # puts "Now Dirty: #{dirty_attributes.keys.join(', ')}\nUpdated: #{old_originals.diff(original_values).keys.join(', ')}"
          return self.save if dirty_attributes.keys.length == (dirty_attributes.keys - old_originals.diff(original_values).keys).length
        end
      end
      !dirty?
    end

    # Reloads the record from Quickbooks, discarding any changes that have been made to it.
    def reload
      self.class.request_and_instantiate(self, self.class.class_leaf_name, :query, :ListID => self.list_id)
    end

    # Destroys a record in Quickbooks. Note that even though Quickbooks will destroy the record, the record's ListID and DeletedTime can be accessed by doing a query for deleted objects of the appropriate type.
    def destroy
      self.class.request_and_instantiate(self, self.class.class_leaf_name, :delete, self.is_a?(Quickbooks::ListItem) ? {:ListID => self.list_id} : {:TxnID => self.txn_id}).success?
    end
  end
end
