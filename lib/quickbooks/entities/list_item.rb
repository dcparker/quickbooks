require 'quickbooks/properties/list_id'
require 'quickbooks/properties/full_name'
require 'quickbooks/properties/edit_sequence'
require 'quickbooks/properties/time_created'
require 'quickbooks/properties/time_modified'
require 'quickbooks/properties/time_deleted'
module Quickbooks
  # A ListItem is identified in quickbooks by ListID. All ListItems also have a unique FullName, so if you know
  # what the FullName of a ListItem is, you can find it that way. Always use the underscore version of finders, such as:
  #   Quickbooks::Customer.first(:list_id => '12345-6789-09876543')
  #   Quickbooks::Deleted.all(:list_del_type => 'Customer', :deleted_after => Time.now - 24*60*60)
  # (See Deleted for specifics on those options.)
  class ListItem < Base
    self.valid_filters = ['list_id', 'full_name']
    self.filter_aliases = {'updated_after' => 'from_modified_date', 'updated_before' => 'to_modified_date'}

    def self.inherited(base)
      super
      # TimeDeleted only comes from ListDeleted, but that way all ListDeleted attributes can be instantiated into their respective ListItem model
      base.properties ListID,
                      FullName,
                      EditSequence[:max_length => {16 => [:QBD, :QBCA, :QBUK, :QBAU], 10 => :QBOE}],
                      TimeCreated,
                      TimeModified,
                      TimeDeleted
    end

    class << self
      def ListOrTxn
        'List'
      end
    end
  end
end
