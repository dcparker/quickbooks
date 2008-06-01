# Contains Quickbooks::Base, which inherits from Quickbooks::Model. Simple objects like BillAddress and CreditCardInfo also
# inherit from Quickbooks::Model, but any objects that are stored as their own 'entity' are below Quickbooks::Base in the
# inheritance tree. Two models inherit directly from Quickbooks::Base: ListItem and Transaction. All other whole-entity
# models inherit from either of these. Only a couple are written so far, as I've had use for them. They're pretty easy to
# write though -- take a look at customer.rb, for example: all that needs defining for most models is any filters (and aliases)
# specific to that model, and a listing of that model's attributes. If you write a model, please send in your code to
# gems@behindlogic.com!
# 
# Inherits from ListItem:
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
# Inherits from Transaction:
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

require 'quickbooks/model'
require 'qbxml'

module Quickbooks
  # Base is just base for ListItem and Transaction. It inherits from Model, just as Ref does.
  # 
  # Some Qbxml specifications require certain finder-options to be placed inside a containing entity, such as:
  #   ...
  #   <DeletedDateRangeFilter>
  #     <FromDeletedDate>#{(Time.now - 5*60*60).xmlschema}</FromDeletedDate>
  #     <ToDeletedDate>#{(Time.now - 3*60*60).xmlschema}</ToDeletedDate>
  #   </DeletedDateRangeFilter>
  #   ...
  # The Quickbooks Models define aliases to these "inside" options. The equivalent to the above [partial] request:
  #   Quickbooks::Deleted.all(:deleted_after => (Time.now - 5*60*60).xmlschema, :deleted_before => (Time.now - 3*60*60).xmlschema)
  # (Type-casting hasn't made it in yet.)
  # 
  # Qbxml makes a special allowance for Deleted items. Much of the time, we'd rather access a model's deleted items through that
  # model class instead of through the deleted class. So Qbxml allows any class to ask for its deleted items through a call like
  # this:
  #   Quickbooks::Customer.deleted(:deleted_after => Time.now - 3*60*60)
  class Base < Model

    self.filter_aliases = {:limit => :max_returned}

    # Stores a log of Qbxml::Response objects that were a result of methods performed on this object.
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

      def use_adapter(adapter)
        # Should complain if the adapter doesn't exist.
        require "#{File.dirname(__FILE__)}/adapters/#{adapter.to_s}_adapter"
        @@connection_adapter = Object.module_eval("::Quickbooks::#{adapter.to_s.camelize}Adapter::Connection", __FILE__, __LINE__)
      end

      def setup(*args)
        @@connection_args = args
      end

      # Establishes a connection to the Quickbooks RDS Server for all Model Classes
      def establish_connection(*args)
        @@connection_adapter ||= use_adapter(:ole)
        @@connection = @@connection_adapter.new(*args)
      end

      # Returns the current Connection
      def connection
        @connection || (@@connection ||= self.establish_connection(*(@@connection_args)))
      end

      # Sets the current Connection.
      # 
      # This is normally not needed, but in the case that you may want to connect a separate connection to Quickbooks,
      # you can use this method to explicitly set the connection in a class that inherits from Quickbooks::Base.
      #   Quickbooks::Models::Base.connection = Quickbooks::Connection.new('My Test App', 'C:\\Some File.QBW', 'user', 'pass')
      def connection=(conn)
        raise ArgumentError, "Cannot set connection to anything but a (*)Adapter::Connection object" unless conn.class.name =~ /Adapter::Connection$/
        @connection = conn
      end

      def connected?
        @connection.nil? ? false : @connection.connected?
      end

      # Generates a request by sending *args to Qbxml::Request.new, sends the request over the current connection,
      # and interprets the response using Qbxml::ResponseSet.
      # The response is then instantiated into an object or an array of objects.
      # 
      # This method is used mostly internally, but it is the yoke of this library - use it to perform custom requests.
      def query(obj_or_args,*args)
        # If an object is sent, we need to reinstantiate the response into that object
        reinstantiate = if obj_or_args.is_a?(Quickbooks::Base)
          obj_or_args
        elsif obj_or_args.is_a?(Class)
          nil
        else
          args.unshift(obj_or_args)
          nil
        end
        objects = [] # This will hold and return the instantiated objects from the quickbooks response
        # The following line is subject to unexpected results: IF the response contains more than one object, it will re-instantiate only the last one.
        self.request(reinstantiate || self, *args).each { |response| objects.concat(response.instantiate(reinstantiate)) } # Does not instantiate if it's an error, but simply records response into response_log
        # Since Quickbooks only honors the Date in queries, we can filter the list further here to honor the Time requested.
        # filters we're triggered on: created_before, created_after, updated_before, updated_after, deleted_before, deleted_after
        if args[-1].is_a?(Hash) && !(time_filters = args[-1].stringify_keys.only('created_before', 'created_after', 'updated_before', 'updated_after', 'deleted_before', 'deleted_after')).empty?
          objects.reject! do |object|
            passes = true if object # When there are no results, we actually get [nil]
            time_filters.each do |filter,time|
              break unless passes # Skip the rest of the tests if it fails one
              case filter
              when 'created_before'
                passes = Time.parse(object.time_created)  <  Time.parse(time.to_s)
              when 'created_after'
                passes = Time.parse(object.time_created)  >= Time.parse(time.to_s)
              when 'updated_before'
                passes = Time.parse(object.time_modified) <  Time.parse(time.to_s)
              when 'updated_after'
                passes = Time.parse(object.time_modified) >= Time.parse(time.to_s)
              when 'deleted_before'
                passes = Time.parse(object.time_deleted)  <  Time.parse(time.to_s)
              when 'deleted_after'
                passes = Time.parse(object.time_deleted)  >= Time.parse(time.to_s)
              end
            end
            !passes
          end
        end
        # ****
        objects.length == 1 ? objects[0] : objects # Here, we may rather always return an array, then methods such as .first can return just the first element
      end

      # Generates a request using Qbxml::Request, sends it, and returns a Qbxml::ResponseSet object containing the response(s).
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
            obj.original_values[key.to_s.underscore] = obj.instance_variable_get('@' + key.to_s.underscore).dup
          end
        end if attrs
        obj # Will be either a nice object, or a Qbxml::Error object.
      end

      # Queries Quickbooks for all of the objects of the current class's type. For example, Quickbooks::Customer.all will return an array of Quickbooks::Customer objects representing all customers.
      def all(filters={})
        filters.reverse_merge!(:active_status => 'All')
        [query(self, :query, filters)].flatten
      end

      # Queries Quickbooks for the first object of the current class's type. For example, Quickbooks::Customer.first will return a Quickbooks::Customer object representing the first customer.
      def first(filters={})
        (filters.merge!(:max_returned => 1) unless filters.keys.include?(:list_id) || filters.keys.include?(:txn_id) || filters.keys.include?(:full_name)) if filters.is_a?(Hash)
        query(self, :query, filters)
      end

      # Still in testing... these should be equivalent:
      #   Quickbooks::Customer.deleted(:deleted_before => Time.now) == Quickbooks::Deleted.all(:type => 'Customer', :deleted_before => Time.now)
      def deleted(filters={})
        query(self, :deleted, filters)
      end

      # Creates a new object of the current class's type. For example, Quickbooks::Customer.create(:name => 'Tommy') will create a customer object with a Name of Tommy.
      def create(*args)
        new(*args).save
      end
    end

    # Generates a new object that can be saved into Quickbooks once the required attributes are set.
    def initialize(*args)
      super # from Quickbooks::Model - sets the *args into attributes
      @new_record = true
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
      self.errors.clear # Clear out any errors: start with a clean slate!
      if new_record?
        self.class.query(self, :add)
        ret = !dirty?
        @new_record = false if ret
      else
        # Smart system that respects EditSequences and other people's changes.
        # 1) Try to save
        # 2) When we get a status of 3200, that means our EditSequence is not up to date
        # 3) Replace self's original_attributes with those just retrieved, and update the automatic attributes, like EditSequence and TimeModified
        # 4) Return false, return the object dirty but ready to save
        old_originals = original_values.dup # Save the old_originals so we can detect any attributes that changed since we last loaded the object
        ret = self.class.query(self, :mod).error? ? false : true # Saves if possible, if EditSequence is out of date, it will read the up-to-date object into original_values
        # If save failed (dirty?) because of old record (status 3200), but none of the fields conflict (attributes I've modified and are still different aren't the same attributes as any of the attributes someone else updated), then re-save!
        if dirty? && self.response_log.last.status == 3200 && (dirty_attributes.only(dirty_attributes(old_originals).keys).keys - self.class.read_only.stringify_values).length == (dirty_attributes(old_originals).keys - old_originals.diff(original_values).keys - self.class.read_only.stringify_values).length
          # 'Revert' fields I didn't modify to equal the values of the more up-to-date record just loaded.
          # Fields I didn't modify: dirty_attributes - dirty_attributes(old_originals).keys
          (dirty_attributes - dirty_attributes(old_originals).keys).each_key do |at|
            self.send(at + '=', original_values[at]) if respond_to?(at + '=')
          end
          ret = self.save
        end
      end
      # ret should be a false value if self has errors. Either way, ret gets the errors too.
      ret.errors << self.errors if self.error?
      # Should be true or false with an error attached.
      ret
    end

    # Reloads the record from Quickbooks, discarding any changes that have been made to it.
    def reload
      self.class.query(self, :query)
    end

    # Destroys a record in Quickbooks. Note that even though Quickbooks will destroy the record,
    # the record's ListID and DeletedTime can be accessed by doing a query for deleted objects of the appropriate type.
    def destroy
      self.class.query(self, :delete).nil?
    end

    # Usual comparison (super), but add in false if either is a new record.
    def ==(other)
      return false unless other.is_a?(self.class)
      return false if self.new_record? || other.new_record?
      super
    end
  end
end
