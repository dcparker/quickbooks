module Quickbooks
  class Deleted < Base
    self.filter_aliases = {'type' => 'list_del_type', 'deleted_after' => 'deleted_date_range_filter/from_deleted_date', 'deleted_before' => 'deleted_date_range_filter/to_deleted_date'}
  end

  class ListDeleted < Deleted
    self.valid_filters = ['list_del_type', 'deleted_date_range_filter/from_deleted_date', 'deleted_date_range_filter/to_deleted_date']
    class << self
      def ListOrTxn
        'List'
      end
    end
  end
  class TxnDeleted < Deleted
    self.valid_filters = ['txn_del_type' 'deleted_date_range_filter/from_deleted_date', 'deleted_date_range_filter/to_deleted_date']
    class << self
      def ListOrTxn
        'Txn'
      end
    end
  end
end
