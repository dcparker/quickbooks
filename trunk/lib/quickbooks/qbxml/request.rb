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
      # @type = there are four types of queries...
        # 1) List queries (:query)
        # 2) Object-specific transaction query (:transaction)
        # 3) Generic transaction query (:any_transaction)
        # 4) Reports (:report)
      # ...and then there are Mod requests...
      # # 1) Mod request (:mod)
      def initialize(object, type, options={})
        @type = type
        raise ArgumentError, "Quickbooks::Qbxml::Requests can only be of one of the following types: :query, :transaction, :any_transaction, :mod, :add, :delete, or :report" unless @type.is_one_of?(:query, :transaction, :any_transaction, :mod, :report, :add, :delete)
        @object = object
        @filters = options if @type.is_one_of?(:query, :transaction, :any_transaction, :report)
        @attributes = options.stringify_keys! if @type.is_one_of?(:mod, :add, :delete)
        # puts self.inspect
      end

      def self.next_request_id
        @request_id ||= 5000
        @request_id += 1
      end

      # This is where the magic happens to convert a request object into xml worthy of sending off to quickbooks.
      def to_xml(as_set=true)
        return (RequestSet.new(self)).to_xml if as_set # Simple call yields xml as a single request in a request set. However, if the xml for the lone request is required, pass false.
        req = Builder::XmlMarkup.new(:indent => 2)
        case
        when @type.is_one_of?(:query)
          request_root = "#{@object}QueryRq"
          container = nil
        when @type == :mod
          request_root = "#{@object}ModRq"
          container = "#{@object}Mod"
        when @type == :add
          request_root = "#{@object}AddRq"
          container = "#{@object}Add"
        when @type == :delete
          # request_root = "#{@object}DelRq"
          request_root = Quickbooks::ListItem.child_types.include?(@object) ? 'ListDelRq' : 'TxnDelRq'
          container = nil
          # container = Quickbooks::ListItem.child_types.include?(@object) ? 'ListDelType' : 'TxnDelType'
          @attributes.merge!((Quickbooks::ListItem.child_types.include?(@object) ? 'ListDelType' : 'TxnDelType') => @object)
        else
          raise RuntimeError, "Could not convert this request to qbxml!\n#{self.inspect}"
        end
        inner_stuff = lambda {
          ['ListDelType', 'TxnDelType', 'ListID', 'TxnID', 'EditSequence'].each do |key|
            req.tag!(key, @attributes.delete(key)) if @attributes.has_key?(key)
          end if @attributes
          (@filters || @attributes).each do |key,value|
            req.tag!(key, value)
          end
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
    end

    module RequestSetArrayExt
    end
  end
end
