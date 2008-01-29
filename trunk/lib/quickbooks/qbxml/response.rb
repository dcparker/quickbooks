require 'quickbooks/ruby_magic'

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

      def instantiate(reinstantiate=nil)
        objs = []
        (self.ret_items.is_a?(Array) ? self.ret_items : [self.ret_items]).each do |ret_item|
          obj = reinstantiate if reinstantiate
          if instantiatable?
            if self.status == 0
              if obj.nil?
                obj = "Quickbooks::#{self.response_type}".constantize.instantiate(ret_item)
              else
                obj.class.instantiate(obj, ret_item)
              end
            else
              # Instantiatable, but some error status. For any error status
              if obj.nil? # Must be a new object. Just as well, create a new object WITHOUT any original_attributes.
                obj = "Quickbooks::#{self.response_type}".constantize.new(ret_item)
              else # An existing object. Must be an update or delete request. Update object's original_attributes.
                updated = []
                ret_item.each do |k,v|
                  k = k.underscore
                  if obj.original_values[k] != v
                    updated << k
                    if obj.class.instance_variable_get('@object_properties').has_key?(k.to_sym)
                      obj.original_values[k] = obj.class.instance_variable_get('@object_properties')[k.to_sym].new(v)
                    else
                      obj.original_values[k] = v
                    end
                  end
                end
                # Update object's 'read-only' attributes (as well as in the original_values):
                obj.class.read_only.stringify_values.camelize_values.each do |k|
                  obj.send(k.underscore + '=', ret_item[k]) if ret_item.has_key?(k) && obj.respond_to?(k.underscore + '=')
                end
                self.message = self.message + " Other properties were out of date: [" + updated.join(', ') + '].'
              end
              obj.errors << {:code => self.status, :message => self.message, :response => self}
            end
          else
            if self.status == 0
              obj.errors << {:code => nil, :message => "Cannot instantiate object of type #{self.response_type}!", :response => self}
            else
              obj.errors << {:code => self.status, :message => self.message, :response => self}
            end
          end
          obj.response_log << self unless obj.nil?
          objs << obj
        end
        objs.length > 1 ? objs : objs[0] # Single or nil if not more than one.
      end
    end

    module ResponseSetArrayExt
    end
  end
end
