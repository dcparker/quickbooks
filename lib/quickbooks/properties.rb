module Quickbooks
  # Property is primarily defined in property.rb
  class Property
  end
  # Entity is primarily defined in entity.rb
  class Entity < Property
  end
  # EmbeddedEntity is primarily defined in embedded_entity.rb
  class EmbeddedEntity < Entity
  end
  # # EntityCollection is primarily defined in entity.rb
  # class EntityCollection < Entity
  # end
  # # EmbeddedEntities is primarily defined in embedded_entity.rb
  # class EmbeddedEntities < EntityCollection
  # end

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
          @properties = @properties.select {|p| p.valid_for_current_flavor_and_version?(self)} # Only current flavor-valid properties are ever even considered
          @properties
        else
          args.each do |prop|
            prop = [prop, {}] unless prop.is_a?(Array)
            property = prop[0]
            properties << property
            PropertyIndex[self,property] = prop[1]
            class_eval "
              def #{property.writer_name}(v)
                @#{property.instance_variable_name} = #{property.name}.new(v)
                @#{property.instance_variable_name}.apply_options(PropertyIndex[#{self.class.name},#{property.name}])
              end
              def #{property.reader_name}
                @#{property.instance_variable_name} ||= #{property.name}.new(nil)
              end
            "
          end
        end
      end

      # Read-only attributes: These are attributes, but not modifiable in Quickbooks
      def read_only
        @properties.reject {|p| p.modifiable?}
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
        writer_method = key.is_a?(Symbol) ? key.to_s+'=' : Property[key].writer_name
        if self.respond_to?(writer_method)
          self.send(writer_method, value)
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
# [TODO] This needs to pull from column.reader
        self.instance_variable_get('@' + column.instance_variable_name) != original_values[column.reader_name]
      end
    end

    # Returns a hash of the attributes and their (new) values that have been changed since the object was last loaded or updated from Quickbooks.
    # If you send in some attributes, it will compare to those given instead of original_attributes.
    def dirty_attributes(compare={})
      compare = original_values if compare.empty?
      pairs = {}
      self.class.read_write.each do |column|
        value = instance_variable_get('@' + column.instance_variable_name)
        if value != compare[column.reader_name]
          pairs[column.reader_name] = value
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
