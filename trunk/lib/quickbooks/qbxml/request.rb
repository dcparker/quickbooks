require 'quickbooks/ruby_magic'
require 'builder'

module Quickbooks
  module Qbxml
    VERSION = '6.0'
    class RequestSet
      include Enumerable
      def set
        unless @set.is_a?(Array)
          @set = []
          @set.extend(Quickbooks::Qbxml::RequestSetArrayExt)
        end
        @set
      end
      delegate_methods [:each, :length, :first, :last, :[], :map, :join] => :set
      def <<(qbxml_request)
        if qbxml_request.is_a?(Quickbooks::Qbxml::Request)
          set << qbxml_request
        elsif qbxml_request.respond_to?(:each)
          qbxml_request.each do |request|
            self << request
          end
        else
          raise ArgumentError, "Cannot add object of type #{qbxml_request.class.name} to a Quickbooks::Qbxml::RequestSet"
        end
      end

      def initialize(*requests)
        self << requests
      end

# <!-- You may optionally have ListID OR FullName OR ( MaxReturned AND ActiveStatus AND FromModifiedDate AND ToModifiedDate AND ( NameFilter OR NameRangeFilter ) )  -->
      def to_xml
        pre = <<-thequickbooks_qbxmlrequestsetxml
<?xml version="1.0" ?>
<?qbxml version="#{Quickbooks::Qbxml::VERSION}" ?>
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
      # 2. Object-specific transaction query (:transaction)
      #   Request.new(Transaction, :query) # <= will return the transaction matching the object supplied
      # 3. Mod requests (:mod)
      #   Request.new(object, :mod) # <= will update the object
      # 4. Delete requests (:delete)
      #   Request.new(object, :delete) # <= will delete the object
      # We want the attributes of the object when we are updating, but no other time.
      def initialize(object, type, options_or_regexp={})
        options = options_or_regexp.is_a?(Regexp) ? {:matches => options_or_regexp} : options_or_regexp
        @type = type
        raise ArgumentError, "Quickbooks::Qbxml::Requests can only be of one of the following types: :query, :transaction, :any_transaction, :mod, :add, :delete, or :report" unless @type.is_one_of?(:query, :transaction, :any_transaction, :mod, :report, :add, :delete)
        @klass = object.is_a?(Class) ? object : object.class
        @object = object
        @options = options

        # Return only specific properties: Request.new(Customer, :query, :only => [:list_id, :full_name]); Quickbooks::Customer.first(:only => :list_id)
        @ret_elements = @options.delete(:only).to_a.only(@klass.properties).order!(@klass.properties).stringify_values.camelize_values!(Quickbooks::CAMELIZE_EXCEPTIONS) if @options.has_key?(:only)

        # Includes only valid filters + aliases for valid filters, then transforms aliased filters to real filters, then camelizes keys to prepare for writing to XML, lastly orders the keys to a valid filter order.
        @filters = options.stringify_keys.only(@klass.valid_filters + @klass.filter_aliases.keys).transform_keys!(@klass.filter_aliases).camelize_keys!(Quickbooks::CAMELIZE_EXCEPTIONS).order!(@klass.camelized_valid_filters)

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
                req.tag!(k.camelcase) { v.each { |k,v| deep_tag.call(k,v) } }
              end
            else
              req.tag!(k.camelcase,uncast(v))
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
            deep_tag.call('',@object.to_dirty_hash) # (this is an hash statically ordered to the model's qbxml attribute order)
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
          @ret_elements.each { |r| req.tag!('IncludeRetElement', r) } if !@ret_elements.blank?
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
        # puts req.target!
        req.target!
      end

      private
        def uncast(v)
          case
          when v.is_a?(Time)
            v.xmlschema
          else
            v
          end
        end
    end

    module RequestSetArrayExt
    end
  end
end
