require 'quickbooks/properties'

# Defines an Entity from Quickbooks. Nesting: An Entity has Properties, which can be Entity's, which contain Properties, and so on.
# An EntityCollection is a container for several Entities and can be used as a Property. Both Entity and EntityCollection are to be
# subclassed, not used directly.
module Quickbooks
  # Property represents a simple Property within an Entity.
  # It simply holds characteristics of each property, cannot have sub-elements (Entity's).
  # An Entity is a Property that can have attributes (sub-elements).
  # Property is primarily defined in property.rb
  class Property
  end

  # An Entity is a Property that can have attributes (sub-elements).
  # Any "Model" in Quickbooks is a subclass of Entity, except for Models that are
  # always embedded in another model and can be repeating.
  class Entity < Property
    include Properties

    class << self
      def inherited(base)
        base.class_eval do
          def initialize(args={})
            self.attributes = args
          end
        end
      end
    end

    # The default for all subclasses is simply to apply the attributes given
    def initialize(args={})
      raise "Inheritance error: Must subclass Entity, never use it directly!"
    end
  end

  # A subclass of EntityCollection will automatically instantiate its values into a collection of Entity objects. For example, if
  # there was a class ElephantCollection, its singular class would be assumed to be Elephant.
  # When an EntityCollection is transcribed to xml, it must be made into a EntityAdd element when creating, or EntityMod element
  # when modifying.
  class EntityCollection < Entity
    class << self
      attr_writer :singular_class
      alias :set_singular_class :singular_class=

      # singular_class may be set explicitly within an EntityCollection subclass; if not it will be inferred from the class name.
      def singular_class
        @singular_class ||= name.gsub(/(Collection|Lst|es|s)$/,'').constantize
      end

      def collection?
        name =~ /Collection$/ ? true : false
      end

      def inherited(base)
        base.class_eval do
          # Instantiates a set containing instances of the singular version of the current model. For example:
          # TxnLineDetailCollection, TxnLineDetailLst, or TxnLineDetails will all be translated to
          # TxnLineDetail for the singular class name.
          def initialize(values=[])
            values = [values] unless values.is_a?(Array)
            values.each do |value|
              set << self.class.singular_class.new(value)
            end
          end
        end
      end
    end

    def initialize(values=[])
      raise "Inheritance error: Must subclass EntityCollection, never use it directly!"
    end

    # Returns the set, or sets a value into the set if given a value
    def set(v=nil)
      v ? (set << v) : (@value ||= [])
    end

    # Not sure if this would do any good in Quickbooks -- can we modify this information and send it back?
    def <<(v)
      raise RuntimeError, "Cannot append items to #{self.class}!" if !appendable?
      set << v
    end

    # When an EntityCollection is transcribed to xml, it must be made into a EntityAdd element when creating, or EntityMod element
    # when modifying.
    def to_xml
      
    end
  end
end
