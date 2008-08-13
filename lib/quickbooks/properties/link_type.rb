module Quickbooks
  class LinkType < EnumProperty
    enum 'AMTTYPE', 'QUANTYPE'
  end
end

#   <!-- LinkType may have one of the following values: AMTTYPE, QUANTYPE -->
#   <LinkType>ENUMTYPE</LinkType>                     <!-- opt, v3.0 -->
