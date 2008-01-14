require 'win32ole'
require 'quickbooks/ole_helper'

module Quickbooks
  # Connection is used internally by Quickbooks::Base to automatically manage a the communication with quickbooks.
  # Currently the only connection mode supported is WIN32OlE, which means your application must be running on the
  # same computer as Quickbooks.
  # 
  # Quickbooks does not allow the user to close the company or exit the program until all outside applications are
  # disconnected from its API. Therefore, this class includes an at_exit hook that automatically closes all open
  # connections for you when your program exits.
  class Connection
    include QBHelpers

    class << self #:nodoc: all
      def connections
        @connections || (@connections = [])
      end
      def connections=(v)
        # raise ArgumentError, "Quickbooks::Connection.connections can only contain Quickbooks::Connection objects, but contains #{v.collect {|c| c.class.name}.uniq.join(', ')} objects" unless v.collect {|c| c.class.name}.uniq == ['Quickbooks::Connection']
        @connections = v
      end

      at_exit do
        Quickbooks::Connection.connections.each do |conn|
          conn.close
        end
      end
    end

    # Initializes an instance of Quickbooks::Session.
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
      connection # Just to make it fail now instead of later if it can't connect properly.
    end

    # Returns true if there is an open connection to Quickbooks, false if not. Use session? to determine an open session.
    def connected?
      @connected ||= false
    end

    # Returns true if there is an active session. Use connected? to determine whether you are connected or not.
    def session?
      !@session.nil?
    end

    # Sends a request to Quickbooks. This request should be a valid QBXML request. Use Quickbooks::Qbxml::Request to generate valid requests.
    def send_xml(xml)
      connection.ProcessRequest(session, xml)
    rescue => e
      warn "ERROR processing request:\n#{xml}"
      raise # Reraises the original error, only this way we got the xml output
    end

    # Returns the active connection to Quickbooks, or creates a new one if none exists.
    def connection
      @connection || begin
        @connection = @quickbooks.ole
        @connection.OpenConnection2('',@application_name,@connection_type)
        Quickbooks::Connection.connections << self
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
      if connected? && connection.CloseConnection(@session)
        @connected = false
        @connection = nil
        Quickbooks::Connection.connections = Quickbooks::Connection.connections - [self]
      end
      return !@connected # Returns false if CloseConnection failed.
    end
  end
end
