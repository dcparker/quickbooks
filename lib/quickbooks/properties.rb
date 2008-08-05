module Quickbooks
  PropertyIndex = Object.new
  class << PropertyIndex
    def index
      @index ||= Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = {}}}
    end
    
    def [](klass,property)
      index[klass][property]
    end
    def []=(klass,property,options)
      index[klass][property] = options
    end
  end

  # Simply defines the way Properties and attributes work. Properties refer to the field names and types for an Entity class,
  # while Attributes refer to the values of those Properties, on instantiated objects.
  module Properties
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Register multiple properties at once. For example:
      #   properties ListID, Name
      # All Attributes should be a ValueAttribute or an EntityAttribute
      def properties(*args)
        if args.empty?
          @properties ||= []
          @properties.select {|p| p.valid_for_current_flavor_and_version?(self)} # Only current flavor-valid properties are ever even considered
        else
          args.each do |prop|
            prop = [prop, {}] unless prop.is_a?(Array)
            properties << prop[0]
            PropertyIndex[self,prop[0]] = prop[1]
            attr_name = prop[0].class_leaf_name.underscore
            class_eval "
              def #{attr_name}=(v)
                @#{attr_name} = #{prop[0].name}.new(v)
                @#{attr_name}.apply_options(PropertyIndex[#{self.class.name},#{prop[0].name}])
              end
              def #{attr_name}
                @#{attr_name}
              end"
          end
        end
      end

      # Read-only attributes: These are attributes, but not modifiable in Quickbooks
      def read_only
        @properties.reject {|p| p.writable?}
      end

      # Read-write attributes: can be modified and saved back to Quickbooks
      def read_write
        @properties - read_only
      end
    end

    # *** *** *** ***
    # Instance Methods

    # Returns a hash that represents all this object's attributes.
    def attributes(include_read_only=false)
      attrs = {}
      (include_read_only ? self.class.properties : self.class.read_write).each do |column|
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
      hsh = SlashedHash.new.ordered!(self.class.read_write.stringify_values)
      self.dirty_attributes.each do |key,value|
        if value.is_a?(Quickbooks::Entity)
          hsh[key] = value.to_dirty_hash
        else
          hsh[key] = value
        end
      end
      hsh
    end

    def to_hash(include_read_only=false)
      hsh = SlashedHash.new.ordered!((include_read_only ? self.class.properties : self.class.read_write).stringify_values)
      self.attributes(include_read_only).each do |key,value|
        if value.is_a?(Quickbooks::Entity)
          hsh[key] = value.to_hash(include_read_only)
        else
          hsh[key] = value
        end
      end
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
    # *** *** *** ***
  end
end
