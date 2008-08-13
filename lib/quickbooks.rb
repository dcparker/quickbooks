require 'rubygems'
require 'quickbooks/ruby_magic'

module Quickbooks
  VERSION = '0.4.31'
  autoload(:Entity, 'quickbooks/entity')
  autoload(:ListDeleted, 'quickbooks/entities/deleted')
  autoload(:TxnDeleted, 'quickbooks/entities/deleted')
  [:Customer, :SalesOrder].each do |name|
    autoload(name, "quickbooks/entities/#{name.to_s.underscore}")
  end

  FLAVORS = [:QBD, :QBCA, :QBUK, :QBAU, :QBOE].freeze
  class << self
    attr_accessor :flavor
    alias :set_flavor :flavor=
    def flavor
      @flavor ||= :QBD
    end

    attr_accessor :version
    alias :set_version :version=
    def version
      @version ||= 7.0
    end
  end
end

require 'quickbooks/property'
require 'quickbooks/properties'
require 'quickbooks/base'
