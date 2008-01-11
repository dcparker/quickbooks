# QBHelpers::Ole is a simple helper class that wraps an OLE object and provides methods that make it easier to deal with certain things that OLE makes complicated.

module QBHelpers
  class Ole
    # Simply holds the actual OLE object.
    attr_reader :ole

    # Pass in the OLE name of the application you want connected to, and the name of a type library, if you need one.
    def initialize(ole_app, type_library=nil)
      @ole_app = ole_app
      @type_library = type_library
      @ole = WIN32OLE.new(ole_app)
      self.classes
    end

    # Finds an OLE variable in the OLE type library, if you specified one in new().
    # This navigates the OLE classes and constants for you and returns the variable that matches the _var_name_ you specify.
    # This is used with Quickbooks to get the qbFileOpenDoNotCare parameter to pass to the OpenConnection2 method:
    #   @quickbooks = Ole.new('QBXMLRP2.RequestProcessor', 'QBXMLRP2 1.0 Type Library')
    #   @quickbooks.OpenConnection2('','Sample Application',@quickbooks.get_variable('localQBD'))
    #   @session = @quickbooks.BeginSession('',@quickbooks.get_variable('qbFileOpenDoNotCare'))
    #   ...
    def get_variable(var_name)
      return nil unless @type_library
      self.classes.each do |class_name|
        found = self.constant_for(class_name.name).variables.find {|var| var.name == var_name}
        return found if found
      end
    end

    def classes #:nodoc:
      return nil unless @type_library
      @classes ||= WIN32OLE_TYPE.ole_classes(@type_library)
    end

    def constant_for(class_name) #:nodoc:
      return nil unless @type_library
      @constant_for ||= {}
      @constant_for[class_name] ||= WIN32OLE_TYPE.new(@type_library, class_name)
    end

    # method_missing sends all other methods to the OLE object, so you can treat this object as your OLE object.
    def method_missing(method_name, *args)
      @ole.send(method_name, *args)
    end
  end
end
