require 'date'
require 'time'

module Quickbooks
  # Property represents a simple Property within an Entity.
  # It simply holds characteristics of each property, cannot have sub-elements (Entity's).
  # An Entity is a Property that can have attributes (sub-elements).
  class Property
    class << self
      def [](options)
        [self, options]
      end

      def modifiable?
        !@cannot_modify
      end
      def cannot_modify!
        @cannot_modify = true
      end
      def appendable?
        !@cannot_append
      end
      def cannot_append!
        @cannot_append = true
      end

      # Checks whether this property is valid for the current flavor and version.
      def valid_for_current_flavor_and_version?(klass)
        valids = (Quickbooks::FLAVORS + Quickbooks::version)
        valids.reject! {|e| PropertyIndex[klass,self][:not_in].include?(e)} if PropertyIndex[klass,self][:not_in]
        valids.reject! {|e| !PropertyIndex[klass,self][:only_in].include?(e)} if PropertyIndex[klass,self][:only_in]
        valids
      end
    end

    # The default for all subclasses is simply to apply the attributes given
    def initialize(*args)
      raise "Inheritance error: Must subclass Property, never use it directly!"
    end

    # Options are things like, :only_in, :not_in, etc. This method simply calls all the keys with the values as arguments.
    def apply_options(options)
      options.each do |k,v|
        send(k, v) if respond_to?(k)
      end
    end

    def modifiable?
      @cannot_modify.nil? ? self.class.modifiable? : !@cannot_modify
    end
    def cannot_modify!
      @cannot_modify = true
    end
    def appendable?
      @cannot_append.nil? ? self.class.appendable? : !@cannot_append
    end
    def cannot_append!
      @cannot_append = true
    end
  end

  class ValueProperty < Property
    class << self
      def inherited(base)
        base.class_eval do
          def initialize(value=nil)
            @value = value
            validate!
          end
        end
      end

      def validations
        @validations ||= []
      end
    end

    def validations
      @validations ||= self.class.validations
    end

    # Sets or retrieves the max_length set on a ValueProperty object.
    # Send in either length, or length => [:QBD, :QBUK], length_2 => :QBOE
    def max_length(lengths=nil)
      @max_length ||= {}
      return @max_length[Quickbooks::flavor] if lengths.nil?
      raise "Cannot set max_length more than once!" unless @max_langth.empty?

      lengths = {lengths => Quickbooks::FLAVORS} unless lengths.is_a?(Hash)
      lengths.each do |length,flavors|
        flavors = [flavors] unless flavors.is_a?(Array)
        flavors.each do |flavor|
          @max_length[flavor] = length
        end
      end
      validations << ["Length is greater than #{max_length}", lambda {|value| value.length <= max_length}]
    end

    def value=(v)
      @value = v
      validate!
    end
    def value
      cast(@value)
    end

    def to_xml
      value.to_s
    end

    private
      def cast(v)
        v.to_s
      end

      def validate!
        self.class.validations.each do |validation|
          raise ValidationError, validation[0] if validation[1].call(*([self,value].reverse[0..validation[1].arity-1])) == false
        end
      end
  end

  # An Entity is a Property that can have attributes (sub-elements).
  # This class is primarily defined in entity.rb
  class Entity < Property
  end

  class BooleanProperty < ValueProperty
    validations << ["Must be a boolean value", lambda {|value| value.is_a?(TrueClass) || value.is_a?(FalseClass)}]
    
    def to_xml
      value ? 'True' : 'False'
    end
    private
      def cast(v)
        v ? true : false
      end
  end
  class StringProperty < ValueProperty
    validations << ["Must be a string value", lambda {|value| value.is_a?(String)}]
  end
  class DateTimeProperty < ValueProperty
    validations << ["Must be a datetime value", lambda {|value| value.is_a?(Date) || value.is_a?(DateTime) || value.is_a?(Time)}]

    def to_xml
      value.xmlschema
    end
  end
  class DateProperty < ValueProperty
    validations << ["Must be a datetime value", lambda {|value| value.is_a?(Date) || value.is_a?(DateTime) || value.is_a?(Time)}]

    def to_xml
      value.xmlschema
    end
    
    private
      def cast(v)
        v.to_date
      end
  end
  class EnumProperty < ValueProperty
    def self.values(*enum)
      if enum.empty?
        @values ||= []
      else
        values.concat(enum)
      end
    end
    validations << ["Must be one of #{values.inspect}", lambda {|value| values.include?(value)}]
  end
  class AmountProperty < ValueProperty
    # validations << ["Must be a valid dollar value", lambda {|value| value.to_s =~ /[\d,]+\.\d\d/}]
  end
  class IntegerProperty < ValueProperty
    validations << ['Must be an integer', lambda {|value| value.is_a?(Integer)}]

    class << self
      def min_value(v)
        validations << ["Minimum value is #{v}", lambda {|value| value >= v}]
      end
      def max_value(v)
        validations << ["Maximum value is #{v}", lambda {|value| value <= v}]
      end
    end

    private
      def cast(v)
        v.to_i
      end
  end
  class PriceProperty < ValueProperty
  end
  class PercentProperty < ValueProperty
  end
  class Ref < Entity
    # Put in here the connector code that can find the ref'd item.
  end
end
