# An embedded entity is an entity that resides within another entity, but in order to be modified it must be explicitly modified,
# not replaced, like most properties.
# For example, a SalesOrder is created with SalesOrderLines. For most purposes a SalesOrderLine can be treated as any typical Property, but
# if you want to modify the SalesOrderLine, you cannot just modify the SalesOrder with the new SalesOrderLine, like you would with most
# properties. Instead, you have to include an SalesOrderLineMod element inside the SalesOrderMod entity, with your modifications.
# In dealing with these "properties", you have to remember that the individual Entity in question makes no sense outside of the context
# of the parent Base Entity.

# : dev :
# This is currently an overlap of the purpose of EntityCollection. Choose a name and stick with it.
# 1) must know its parent; it must be told its parent upon instantiation.
# 2) must delegate "save" methods to its parent
# not sure if EmbeddedEntities really should inherit from EntityCollection or not.
require 'quickbooks/entity'
module Quickbooks
  class EmbeddedEntities < EntityCollection
    def self.writer_name
      @writer_name ||= "#{singular_class.class_leaf_name.underscore}_ret="
    end
  end

  class EmbeddedEntity < Entity
    def self.writer_name
      @writer_name ||= "#{class_leaf_name.underscore}_ret="
    end
  end
end
