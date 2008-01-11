require 'quickbooks/ruby_magic'
require 'quickbooks/qbxml/error'

module Quickbooks
  module Qbxml
    class ResponseSet
      include Enumerable
      def set
        unless @set.is_a?(Array)
          @set = []
          @set.extend(Quickbooks::Qbxml::ResponseSetArrayExt)
        end
        @set
      end
      delegate_methods [:each, :length, :first, :last, :[], :map, :join] => :set
      def <<(qbxml_response)
        if qbxml_response.is_a?(Quickbooks::Qbxml::Response)
          set << qbxml_response
        elsif qbxml_response.respond_to?(:each)
          qbxml_response.each do |response|
            self << response
          end
        else
          raise ArgumentError, "Cannot add object of type #{qbxml_response.class.name} to a Quickbooks::Qbxml::ResponseSet"
        end
      end

      def initialize(xml_or_hash)
        if(xml_or_hash.is_a?(Hash))
          self.append_from_hash(xml_or_hash)
        elsif(xml_or_hash.is_a?(String))
          self.append_from_xml(xml_or_hash)
        else
          raise ArgumentError, "Quickbooks::Qbxml::ResponseSet must be initialized with either a Hash or an xml-formatted String."
        end
      end

      def append_from_xml(xml)
        self.append_from_hash(Hash.from_xml(xml))
      end
      def append_from_hash(hsh)
        to_append = []
        hsh = hsh['QBXML'] if hsh.has_key?('QBXML')
        hsh = hsh['QBXMLMsgsRs'] if hsh.has_key?('QBXMLMsgsRs')
        # responses will contain one or more keys.
        hsh.each_key do |name|
          # response_type is either a single response object, or an array of response objects. Force it into an array:
          responses = hsh[name].is_a?(Array) ? hsh[name] : [hsh[name]]
          responses.each { |response| to_append << Response.new(name => response) }
        end
        self << to_append
      end

      class << self
        def from_xml(xml)
          new.append_from_xml(xml)
        end
        def from_hash(hsh)
          new.append_from_hash(hsh)
        end
      end
    end

    class Response
      attr_accessor :response_type, :status, :message, :severity, :ret_items
      # For Development purposes:
      attr_accessor :raw_response

      def initialize(xml_or_hash)
        if(xml_or_hash.is_a?(Hash))
          self.import_from_hash(xml_or_hash)
        elsif(xml_or_hash.is_a?(String))
          self.import_from_xml(xml_or_hash)
        else
          raise ArgumentError, "Quickbooks::Qbxml::ResponseSet must be initialized with either a Hash or an xml-formatted String."
        end
      end

      def import_from_xml(xml)
        self.import_from_hash(Hash.from_xml(xml))
        self
      end
      def import_from_hash(hsh)
        raise ArgumentError, "Hash passed to Quickbooks::Qbxml::Response.from_hash must contain only one top-level key" unless hsh.keys.length == 1
        name = hsh.keys.first
        # for development
        self.raw_response = hsh
        # * * * *
        hsh = hsh[name]

        self.status = hsh['statusCode'].to_i
        self.severity = hsh['statusSeverity']
        self.message = hsh['statusMessage']
        # if self.status == 0 # Status is good, proceed with eating the request.
          if m = name.match(/^(List|Txn)Del(etedQuery)?Rs$/)
            # (List|Txn)DelRs, or (List|Txn)DeletedQueryRs - both return just a few attributes, like ListID / TxnID and TimeDeleted
            self.response_type = hsh.delete(m[1]+'DelType')
            # self.ret_items = ResponseObject.new(self.response_type, hsh.dup)
            self.ret_items = hsh.dup
          elsif m = name.match(/^([A-Za-z][a-z]+)(Query|Mod|Add)Rs$/)
            self.response_type = m[1]
            # self.ret_items = ResponseObject.new(self.response_type, hsh[self.response_type+'Ret'])
            self.ret_items = hsh[self.response_type+'Ret']
          else
            raise "Could not read this response:\n#{self.raw_response.inspect}"
          end
        # else # Status is bad.
          
        # end
        # puts self.inspect
        self
      end


      class << self
        def from_xml(xml)
          new.import_from_xml(xml)
        end
        def from_hash(hsh)
          new.import_from_hash(hsh)
        end
      end

      def instantiatable? # Just checks to see if it can create an object of this type, and if there is actually data to instantiate
        self.response_type ? (Quickbooks.const_defined?(self.response_type) && self.ret_items.is_a?(Hash) || (self.ret_items.is_a?(Array) && self.ret_items[0].is_a?(Hash))) : false
      end
      def success?
        self.status == 0
      end
      def error?
        !success?
      end

      def instantiate(obj=nil)
        objs = []
        (self.ret_items.is_a?(Array) ? self.ret_items : [self.ret_items]).each do |ret_item|
          if instantiatable?
            if self.status == 0
              if obj.nil?
                obj = "Quickbooks::#{self.response_type}".constantize.instantiate(self.ret_items)
              else
                obj.class.instantiate(obj, self.ret_items)
              end
            else
              # Instantiatable, but some error status. For any error status
              if obj.nil? # Must be a new object. Just as well, create a new object WITHOUT any original_attributes.
                obj = "Quickbooks::#{self.response_type}".constantize.new(self.ret_items)
              else # An existing object. Must be an update or delete request. Update object's original_attributes.
                updated = []
                self.ret_items.each do |k,v|
                  k = k.underscore
                  if obj.original_values[k] != v
                    updated << k
                    obj.original_values[k] = v
                  end
                end
                ['EditSequence', 'TimeModified', 'TimeCreated'].each do |k|
                  obj.send(k.underscore + '=', self.ret_items[k]) if self.ret_items.has_key?(k) && obj.respond_to?(k.underscore + '=')
                end
                self.message = self.message + " Other properties were out of date: [" + updated.join(', ') + '].'
              end
            end
          else
            obj = Quickbooks::Qbxml::Error.new(self) # If not instantiatable, use this 'Error' object just as a wrapper for the response_log to convey the error response.
          end
          obj.response_log << self
          objs << obj
        end
        objs.length > 1 ? objs : objs[0] # Single or nil if not more than one.
      end
    end

    module ResponseSetArrayExt
    end
  end
end
