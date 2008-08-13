module Quickbooks
  class JobStatus < EnumProperty
    enum 'Awarded', 'Closed', 'InProgress', 'None', 'NotAwarded', 'Pending'
  end
end
