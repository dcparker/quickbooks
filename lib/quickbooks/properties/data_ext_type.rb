module Quickbooks
  class DataExtType < EnumProperty
    enum 'AMTTYPE', 'DATETIMETYPE', 'INTTYPE', 'PERCENTTYPE', 'PRICETYPE', 'QUANTYPE', 'STR1024TYPE', 'STR255TYPE'
  end
end
