require 'quickbooks/ruby_magic'
require 'quickbooks/structure'
module Quickbooks
  CAMELIZE_EXCEPTIONS = {'list_id' => 'ListID', 'txn_id' => 'TxnID', 'owner_id' => 'OwnerID'}
  # These were all created from the info in qbxmlops70.xml, found in the docs in the QBSDK package.
  class Model
    class << self

      def inherited(klass)
        def klass.valid_filters
          (superclass.valid_filters + (@valid_filters ||= [])).flatten_slashes
        end
        def klass.filter_aliases
          seed = [superclass.filter_aliases].flatten_slashes.expand_slashes.flatten_slashes
          (seed.empty? ? {} : seed).merge(@filter_aliases ||= {})
        end
        klass.instance_variable_set('@object_properties', {})
      end
      
      def valid_filters=(v)
        @valid_filters = v.stringify_values!.flatten_slashes
      end
      def valid_filters
        (@valid_filters ||= []).flatten_slashes
      end
      def filter_aliases=(v)
        al = [v].flatten_slashes.expand_slashes.flatten_slashes
        @filter_aliases = al.empty? ? {} : al
      end
      def filter_aliases
        @filter_aliases ||= {}
      end
      def camelized_valid_filters
        cvf = []
        valid_filters.each do |v|
          cvf << (Quickbooks::CAMELIZE_EXCEPTIONS.has_key?(v) ? Quickbooks::CAMELIZE_EXCEPTIONS[v] : (v.is_a?(Symbol) ? v.to_s.camelize.to_sym : v.split('/').map {|e| e.camelize}.join('/')))
        end
        cvf
      end
      
      # Register multiple read/writable properties at once. For example:
      #   read_write :first_name, :last_name, :phone, :alt_phone
      # For reference attributes (like parent_ref), use ParentRef - a class constant for that object.
      # _read_write_ will set the property setter and accessor accordingly.
      def read_write(*args)
        if args.empty?
          @read_write || (@read_write = [])
        else
          args.each do |prop|
            if prop.is_a?(Symbol)
              read_write << prop
              attr_accessor prop
            else
              @object_properties[prop.class_leaf_name.underscore.to_sym] = prop
              read_write << prop.class_leaf_name.underscore.to_sym
              class_eval "def #{prop.class_leaf_name.underscore}=(v); @#{prop.class_leaf_name.underscore} = #{prop.name}.new(v); end
                def #{prop.class_leaf_name.underscore}; @#{prop.class_leaf_name.underscore}; end"
            end
          end
        end
      end

      # Read-only attributes: These are attributes, but not modifiable in Quickbooks
      def read_only(*args)
        if args.empty?
          @read_only || (@read_only = [])
        else
          args.each do |prop|
            if prop.is_a?(Symbol)
              read_only << prop
              attr_accessor prop
            else
              @object_properties[prop.class_leaf_name.underscore.to_sym] = prop
              read_only << prop.class_leaf_name.underscore.to_sym
              class_eval "def #{prop.class_leaf_name.underscore}=(v); @#{prop.class_leaf_name.underscore} = #{prop.name}.new(v); end
                def #{prop.class_leaf_name.underscore}; @#{prop.class_leaf_name.underscore}; end"
            end
          end
        end
      end

      def properties
        read_only + read_write
      end
    end

    self.valid_filters = [:max_returned]

    # The default for all subclasses is simply to apply the attributes given, and mark the object as a new_record?
    def initialize(args={})
      self.attributes = args
    end

    # Returns a hash that represents all this object's attributes.
    def attributes(include_read_only=false)
      attrs = {}
      (include_read_only ? self.class.read_only + self.class.read_write : self.class.read_write).each do |column|
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
      self.class.read_write.any? do |column|
        self.instance_variable_get('@' + column.to_s) != original_values[column.to_s]
      end
    end

    # Returns a hash of the attributes and their (new) values that have been changed since the object was last loaded or updated from Quickbooks.
    # If you send in some attributes, it will compare to those given instead of original_attributes.
    def dirty_attributes(compare={})
      compare = original_values if compare.empty?
      pairs = {}
      self.class.read_write.each do |column|
        value = instance_variable_get('@' + column.to_s)
        if value != compare[column.to_s]
          pairs[column.to_s] = value
        end
      end
      pairs
    end

    def to_dirty_hash
      hsh = {}
      self.dirty_attributes.each do |key,value|
        if value.is_a?(Quickbooks::Model)
          h = value.to_dirty_hash
          hsh[key] = h unless h.empty?
        else
          hsh[key] = value
        end
      end
      hsh.ordered!(self.class.read_write.stringify_values)
      hsh
    end

    def to_hash(include_read_only=false)
      hsh = {}
      self.attributes(include_read_only).each do |key,value|
        if value.is_a?(Quickbooks::Model)
          h = value.to_hash(include_read_only)
          hsh[key] = h unless h.empty?
        else
          hsh[key] = value
        end
      end
      hsh.ordered!((include_read_only ? self.class.read_only + self.class.read_write : self.class.read_write).stringify_values)
      hsh
    end

    def ==(other)
      return false unless other.is_a?(self.class)
      !self.class.read_write.any? do |column|
        self.instance_variable_get('@' + column.to_s) != other.instance_variable_get('@' + column.to_s)
      end
    end

    def ===(other)
      # other could be a hash
      if other.is_a?(Hash)
        self == self.class.new(other)
      else
        self == other
      end
    end
  end
end
