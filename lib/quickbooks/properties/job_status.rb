module Quickbooks
  class JobStatus < EnumProperty
    values 'Awarded', 'Closed', 'InProgress', 'None', 'NotAwarded', 'Pending'
  end
end
