require 'qbxml/support'
require 'builder'
require 'time'
require 'hash_magic'

module Qbxml
  class RequestSet
    include Enumerable
    def set
      unless @set.is_a?(Array)
        @set = []
      end
      @set
    end
    delegate_methods [:each, :length, :first, :last, :[], :map, :join] => :set
    def <<(qbxml_request)
      if qbxml_request.is_a?(Qbxml::Request)
        set << qbxml_request
      elsif qbxml_request.respond_to?(:each)
        qbxml_request.each do |request|
          self << request
        end
      else
        raise ArgumentError, "Cannot add object of type #{qbxml_request.class.name} to a Qbxml::RequestSet"
      end
    end

    def initialize(*requests)
      self << requests
    end

    def to_xml
      pre = <<-thequickbooks_qbxmlrequestsetxml
<?xml version="1.0" ?>
<?qbxml version="#{Qbxml::VERSION}" ?>
<QBXML>
<QBXMLMsgsRq onError="stopOnError">
thequickbooks_qbxmlrequestsetxml
      requests = map {|x| x.to_xml(false)}.join
      post = <<-thequickbooks_qbxmlrequestsetxml
</QBXMLMsgsRq>
</QBXML>
thequickbooks_qbxmlrequestsetxml
# puts pre + requests + post
      pre + requests + post
    end
  end

  class Request
    # 1. List queries (:query)
    #   Request.new(object, :query) # <= will return the record matching the object supplied (automatically searches by list_id or txn_id)
    #   Request.new(Customer, :query, :limit => 1) # <= will return the first customer
    #   Request.new(Customer, :query, /some match/) # <= will return all customers matching the regexp
    # 2. Deleted queries (:deleted)
    #   Request.new(object, :deleted) # <= INVALID!! (besides, you wouldn't have an object to check up on anyway :P )
    #   Request.new(Customer, :deleted) # <= will return all deleted Customers
    #   Request.new(Customer, :deleted, :deleted_date_range_filter => {'from_deleted_date' => Date.parse('2008/10/05')}) # <= will return all Customers deleted since 5 October 2008
    # 3. Object-specific transaction query (:transaction)
    #   Request.new(Transaction, :query) # <= will return the transaction matching the object supplied
    # 4. Mod requests (:mod)
    #   Request.new(object, :mod) # <= will update the object
    # 5. Delete requests (:delete)
    #   Request.new(object, :delete) # <= will delete the object
    # We want the attributes of the object when we are updating, but no other time.
    def initialize(object, type, options_or_regexp={})
      options = options_or_regexp.is_a?(Regexp) ? {:matches => options_or_regexp} : options_or_regexp
      @type = type
      raise ArgumentError, "Qbxml::Requests can only be of one of the following types: :query, :transaction, :any_transaction, :mod, :add, :delete, :deleted, or :report" unless @type.is_one_of?(:query, :transaction, :any_transaction, :mod, :report, :add, :delete, :deleted)
      @klass = object.is_a?(Class) ? object : object.class
      @object = object
      @options = options

      # Transform the options received for :deleted requests.
      # This way, Request.new(Customer, :deleted) == Request.new(ListDeleted, :list_del_type => 'Customer')
      # and Request.new(Transaction, :deleted) == Request.new(TxnDeleted, :txn_del_type => 'Transaction')
      if @type == :deleted
        case @klass.ListOrTxn
        when 'List'
          @options[:list_del_type] = @klass.lone_name
          @klass = Quickbooks::ListDeleted
        when 'Txn'
          @options[:txn_del_type] = @klass.lone_name
          @klass = Quickbooks::TxnDeleted
        end
      end

      # Return only specific properties: Request.new(Customer, :query, :only => [:list_id, :full_name]); Quickbooks::Customer.first(:only => :list_id)
      @ret_elements = @options.delete(:only).to_a.only(@klass.property_names).ordered(@klass.property_names).stringify_values.camelize_values!(Quickbooks::CAMELIZE_EXCEPTIONS) if @options.has_key?(:only)

      # Includes only valid filters + aliases for valid filters, # => {underscore/slashed keys + aliases}
      # then transforms aliased filters to real filters, # => {underscore/slashed keys}
      # then camelizes keys to prepare for writing to XML, # => {}
      # lastly orders the keys to a valid filter order.

      # Study the following:
      #   @klass.filter_aliases = {'deleted_after' => 'deleted_date_range_filter/from_deleted_date'}
      #   @klass.valid_filters = ['deleted_date_range_filter/from_deleted_date']
      #   {:deleted_after => "2008-03-20T11:20:26-04:00"}.slashed.
      #     only(@klass.valid_filters + @klass.filter_aliases.slashed.flat.keys).
      #     transform_keys!(@klass.filter_aliases.slashed.flat).
      #     slash_camelize_keys!(Quickbooks::CAMELIZE_EXCEPTIONS).slashed.
      #     ordered!(@klass.camelized_valid_filters).slashed.expand
      #   # => {"DeletedDateRangeFilter" => {"FromDeletedDate" => "2008-03-20T11:20:26-04:00"}}
      @filters = @options.delete(:filters) || @options.slashed.
        only(@klass.valid_filters + @klass.filter_aliases.slashed.flat.keys).
        transform_keys!(@klass.filter_aliases.slashed.flat).
        slash_camelize_keys!(Quickbooks::CAMELIZE_EXCEPTIONS).
        ordered!(@klass.camelized_valid_filters)
      @filters = @filters.to_hash unless @filters.is_a?(Hash)
      @filters = @filters['FILTERS'] if @filters.keys == ['FILTERS'] # So if you include an xml-formatted string of filters, you can simply wrap them in <FILTERS></FILTERS> as a root key

      # Complain if:
      #   1) type is :mod or :delete, and object supplied is not a valid model
      raise ArgumentError, "A Quickbooks record object must be supplied to perform an add, mod or del action" if @type.is_one_of?(:add, :mod, :delete) && !@object.is_a?(Quickbooks::Base)
    end

    def self.next_request_id
      @request_id ||= 0
      @request_id += 1
    end

    # This is where the magic happens to convert a request object into xml worthy of quickbooks.
    def to_xml(as_set=true)
      return (RequestSet.new(self)).to_xml if as_set # Simple call yields xml as a single request in a request set. However, if the xml for the lone request is required, pass false.
      req = Builder::XmlMarkup.new(:indent => 2)
      request_root, container = case
      when @type.is_one_of?(:query)
        ["#{@klass.class_leaf_name}QueryRq", nil]
      when @type == :add
        ["#{@klass.class_leaf_name}AddRq", "#{@klass.class_leaf_name}Add"]
      when @type == :mod
        ["#{@klass.class_leaf_name}ModRq", "#{@klass.class_leaf_name}Mod"]
      when @type == :delete
        ["#{@klass.ListOrTxn}DelRq", nil]
      when @type == :deleted
        ["#{@klass.ListOrTxn}DeletedQueryRq", nil]
      else
        raise RuntimeError, "Could not convert this request to qbxml!\n#{self.inspect}"
      end
      inner_stuff = lambda {
        deep_tag = lambda {|k,v|
          if v.is_a?(Hash)
            if k == ''
              v.each { |k,v|
                deep_tag.call(k,v)
              }
            else
              req.tag!(k.camelize) { v.each { |k,e| deep_tag.call(k,e) } }
            end
          elsif v.is_a?(Array)
            req.tag!(k.camelize) { v.each {|e| deep_tag.call(k,e)} }
          else
            req.tag!(k.camelize,v.respond_to?(:to_xml) ? v.to_xml : uncast(v))
          end
        }

        # Add the specific elements for the respective request type
        if @type.is_one_of?(:add, :mod)
          if @type == :mod
            # First the ObjectId:
            req.tag!(@klass.ListOrTxn + 'ID', @object.send("#{@klass.ListOrTxn}Id".underscore))
            # Second the EditSequence
            req.tag!('EditSequence', @object.send(:edit_sequence))
          end
          # Then, all the dirty_attributes
          deep_tag.call('',@object.to_dirty_hash(true)) # (this is an hash statically ordered to the model's qbxml attribute order)
        elsif @type == :query && @object.class == @klass
          # Sent an instance object for a query - we should include the ListId/TxnId (then other filters?)
          req.tag!(@klass.ListOrTxn + 'ID', @object.send("#{@klass.ListOrTxn}Id".underscore))
          deep_tag.call('', @filters)
        elsif @type == :delete
          req.tag!(@klass.ListOrTxn + 'DelType', @klass.class_leaf_name)
          req.tag!(@klass.ListOrTxn + 'ID', @object.send("#{@klass.ListOrTxn}Id".underscore))
        else
          # just filters
          deep_tag.call('', @filters)
        end
        # Lastly, specify the fields to return, if desired
        @ret_elements.each { |r| req.tag!('IncludeRetElement', r) } if @ret_elements.is_a?(Array) && @ret_elements.length > 0
      }
      req.tag!(request_root, :requestID => self.class.next_request_id) {
        if container
          req.tag!(container) {
            inner_stuff.call
          }
        else
          inner_stuff.call
        end
      }
      req.target! # The xml string
    end

    private
      def uncast(v)
        case
        when v.respond_to?(:xmlschema)
          v.xmlschema
        else
          v
        end
      end
  end
end
