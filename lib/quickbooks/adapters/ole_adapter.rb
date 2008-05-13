require 'win32ole'

module Quickbooks
  # Connection is used internally by Quickbooks::Base to automatically manage a the communication with quickbooks.
  # Currently the only connection mode supported is WIN32OlE, which means your application must be running on the
  # same computer as Quickbooks.
  # 
  # Quickbooks does not allow the user to close the company or exit the program until all outside applications are
  # disconnected from its API. Therefore, this class includes an at_exit hook that automatically closes all open
  # connections for you when your program exits.
  module OleAdapter
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

    class Connection
      class << self #:nodoc: all
        def connections
          @connections || (@connections = [])
        end
        def connections=(v)
          # raise ArgumentError, "Quickbooks::Connection.connections can only contain Quickbooks::Connection objects, but contains #{v.collect {|c| c.class.name}.uniq.join(', ')} objects" unless v.collect {|c| c.class.name}.uniq == ['Quickbooks::Connection']
          @connections = v
        end

        at_exit do
          Connection.connections.each do |conn|
            conn.close rescue nil
          end
        end
      end

      # Initializes an instance of Quickbooks::Connection.
      # - _application_name_ is required.
      # - _file_ is optional, in which case the connection will be made to the currently open company file in the Quickbooks application.
      # - _user_ and _password_ may be required if you have specified a specific file to open.
      # - _connection_type_ can be one of: ['unknown', 'localQBD', 'remoteQBD', 'localQBDLaunchUI', 'remoteQBOE']
      # - _connection_mode_ can be one of: ['SingleUser', 'MultiUser', 'DoNotCare']
      def initialize(application_name='RubyApplication', file='', user='', password='', connection_type='localQBD', connection_mode='DoNotCare')
        @file = file
        @user = user
        @password = password
        @application_name = application_name
        @quickbooks = Ole.new('QBXMLRP2.RequestProcessor', 'QBXMLRP2 1.0 Type Library')
        @connection_type = @quickbooks.get_variable(connection_type)
        @connection_mode = @quickbooks.get_variable('qbFileOpen'+connection_mode)
      end

      # Returns true if there is an open connection to Quickbooks, false if not. Use session? to determine an open session.
      def connected?
        @connected ||= false
      end

      # Returns true if there is an active session. Use connected? to determine whether you are connected or not.
      def session?
        !@session.nil?
      end

      # Sends a request to Quickbooks. This request should be a valid QBXML request. Use Qbxml::Request to generate valid requests.
      def send_xml(xml)
        connection.ProcessRequest(session, xml)
      rescue => e
        puts "ERROR processing request:\n#{xml}"
        raise # Reraises the original error, only this way we got the xml output
      end

      # Returns the active connection to Quickbooks, or creates a new one if none exists.
      def connection
        @connection || begin
          @connection = @quickbooks.ole
          @connection.OpenConnection2('',@application_name,@connection_type)
          Connection.connections << self
          @connected = true
          @connection
        end
      end

      # Begin a session to Quickbooks.
      def session
        @session || begin
          @session = connection.BeginSession(@file,@connection_mode)
        end
      end

      # End the current Quickbooks session. After ending a session, a new session may be reopened if desired.
      def end_session
        if !@session.nil?
          connection.EndSession(@session)
          @session = nil
          true
        else
          false
        end
      end

      # Close the connection to Quickbooks. Automatically ends the session, if there is one.
      def close
        end_session
        if connected? && connection.CloseConnection.nil?
          @connected = false
          @connection = nil
          Connection.connections = Connection.connections - [self]
        end
        return !@connected # Returns false if CloseConnection failed.
      end
    end
  end
end
