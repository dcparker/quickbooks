require File.dirname(__FILE__) + '/spec_helper'

describe Qbxml::Request do
  it "should compare xml-formatted strings correctly" do
    customer_query_a = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <CustomerQueryRq requestID = "1">
        </CustomerQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
    shshshshshsh
    customer_query_b = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq>
        <onError>stopOnError</onError>
        <CustomerQueryRq>
          <requestID>1</requestID>
        </CustomerQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
    shshshshshsh

    customer_query_a.formatted(:xml).should === customer_query_b.formatted(:xml)
  end

  it "should render a simple CustomerQuery correctly" do
    customer_query = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <CustomerQueryRq requestID = "1">
        </CustomerQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
    shshshshshsh
    Qbxml::Request.new(Quickbooks::Customer, :query).to_xml.formatted(:xml).should === customer_query.formatted(:xml)
  end

  it "should render a ListDeletedQuery correctly" do
    deleted = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <ListDeletedQueryRq requestID = "2">

          <!--
            ListDelType may have one of the following values:
            Account, BillingRate, Class, Customer, CustomerMsg, CustomerType, DateDrivenTerms,
            Employee, ItemDiscount, ItemFixedAsset, ItemGroup, ItemInventory, ItemInventoryAssembly,
            ItemNonInventory, ItemOtherCharge, ItemPayment, ItemSalesTax, ItemSalesTaxGroup,
            ItemService, ItemSubtotal, JobType, OtherName, PaymentMethod, PayrollItemNonWage,
            PayrollItemWage, PriceLevel, SalesRep, SalesTaxCode, ShipMethod, StandardTerms, ToDo,
            UnitOfMeasureSet, Vehicle, Vendor, VendorType
          -->

          <ListDelType>Customer</ListDelType>

          <!--
            <DeletedDateRangeFilter>
              <FromDeletedDate>DATETIMETYPE</FromDeletedDate>
              <ToDeletedDate>DATETIMETYPE</ToDeletedDate>
            </DeletedDateRangeFilter>
            <IncludeRetElement>STRTYPE</IncludeRetElement>
          -->

        </ListDeletedQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
  shshshshshsh

    Qbxml::Request.new(Quickbooks::Customer, :deleted).to_xml.formatted(:xml).should === deleted.formatted(:xml)
  end

  it "should render a ListDeletedQuery with a from-date correctly" do
    # DATETIMETYPE == Date#strftime("%Y/%M/%D") || Time#strftime("%Y/%M/%D %H/%m/%s")
    deleted = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <ListDeletedQueryRq requestID = "3">

          <!--
            ListDelType may have one of the following values:
            Account, BillingRate, Class, Customer, CustomerMsg, CustomerType, DateDrivenTerms,
            Employee, ItemDiscount, ItemFixedAsset, ItemGroup, ItemInventory, ItemInventoryAssembly,
            ItemNonInventory, ItemOtherCharge, ItemPayment, ItemSalesTax, ItemSalesTaxGroup,
            ItemService, ItemSubtotal, JobType, OtherName, PaymentMethod, PayrollItemNonWage,
            PayrollItemWage, PriceLevel, SalesRep, SalesTaxCode, ShipMethod, StandardTerms, ToDo,
            UnitOfMeasureSet, Vehicle, Vendor, VendorType
          -->

          <ListDelType>Customer</ListDelType>
          <DeletedDateRangeFilter>
            <FromDeletedDate>2008/10/05</FromDeletedDate>
            <!-- <ToDeletedDate>DATETIMETYPE</ToDeletedDate> -->
          </DeletedDateRangeFilter>
        </ListDeletedQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
  shshshshshsh

    Qbxml::Request.new(Quickbooks::Customer, :deleted, :deleted_after => '2008/10/05').to_xml.formatted(:xml).should === deleted.formatted(:xml)
  end

  it "should render a ListDeletedQuery with a to-date correctly" do
    # DATETIMETYPE == Date#strftime("%Y/%M/%D") || Time#strftime("%Y/%M/%D %H/%m/%s")
    deleted = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <ListDeletedQueryRq requestID = "4">

          <!--
            ListDelType may have one of the following values:
            Account, BillingRate, Class, Customer, CustomerMsg, CustomerType, DateDrivenTerms,
            Employee, ItemDiscount, ItemFixedAsset, ItemGroup, ItemInventory, ItemInventoryAssembly,
            ItemNonInventory, ItemOtherCharge, ItemPayment, ItemSalesTax, ItemSalesTaxGroup,
            ItemService, ItemSubtotal, JobType, OtherName, PaymentMethod, PayrollItemNonWage,
            PayrollItemWage, PriceLevel, SalesRep, SalesTaxCode, ShipMethod, StandardTerms, ToDo,
            UnitOfMeasureSet, Vehicle, Vendor, VendorType
          -->

          <ListDelType>Customer</ListDelType>
          <DeletedDateRangeFilter>
            <!-- <FromDeletedDate>2008/10/05</FromDeletedDate> -->
            <ToDeletedDate>2008/11/05</ToDeletedDate>
          </DeletedDateRangeFilter>
        </ListDeletedQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
  shshshshshsh

    Qbxml::Request.new(Quickbooks::Customer, :deleted, :deleted_before => '2008/11/05').to_xml.formatted(:xml).should === deleted.formatted(:xml)
  end

  it "should render a ListDeletedQuery with a from-date and to-date correctly" do
    # DATETIMETYPE == Date#strftime("%Y/%M/%D") || Time#strftime("%Y/%M/%D %H/%m/%s")
    deleted = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <ListDeletedQueryRq requestID = "5">

          <!--
            ListDelType may have one of the following values:
            Account, BillingRate, Class, Customer, CustomerMsg, CustomerType, DateDrivenTerms,
            Employee, ItemDiscount, ItemFixedAsset, ItemGroup, ItemInventory, ItemInventoryAssembly,
            ItemNonInventory, ItemOtherCharge, ItemPayment, ItemSalesTax, ItemSalesTaxGroup,
            ItemService, ItemSubtotal, JobType, OtherName, PaymentMethod, PayrollItemNonWage,
            PayrollItemWage, PriceLevel, SalesRep, SalesTaxCode, ShipMethod, StandardTerms, ToDo,
            UnitOfMeasureSet, Vehicle, Vendor, VendorType
          -->

          <ListDelType>Customer</ListDelType>
          <DeletedDateRangeFilter>
            <FromDeletedDate>2008/10/05</FromDeletedDate>
            <ToDeletedDate>2008/11/05</ToDeletedDate>
          </DeletedDateRangeFilter>
        </ListDeletedQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
  shshshshshsh

    Qbxml::Request.new(Quickbooks::Customer, :deleted, :deleted_after => '2008/10/05', :deleted_before => '2008/11/05').to_xml.formatted(:xml).should === deleted.formatted(:xml)
  end

  it "should render a ListDeletedQuery with {xml filters from-date and to-date} correctly" do
    # DATETIMETYPE == Date#strftime("%Y/%M/%D") || Time#strftime("%Y/%M/%D %H/%m/%s")
    deleted = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <ListDeletedQueryRq requestID = "6">

          <!--
            ListDelType may have one of the following values:
            Account, BillingRate, Class, Customer, CustomerMsg, CustomerType, DateDrivenTerms,
            Employee, ItemDiscount, ItemFixedAsset, ItemGroup, ItemInventory, ItemInventoryAssembly,
            ItemNonInventory, ItemOtherCharge, ItemPayment, ItemSalesTax, ItemSalesTaxGroup,
            ItemService, ItemSubtotal, JobType, OtherName, PaymentMethod, PayrollItemNonWage,
            PayrollItemWage, PriceLevel, SalesRep, SalesTaxCode, ShipMethod, StandardTerms, ToDo,
            UnitOfMeasureSet, Vehicle, Vendor, VendorType
          -->

          <ListDelType>Customer</ListDelType>
          <DeletedDateRangeFilter>
            <FromDeletedDate>2008/10/05</FromDeletedDate>
            <ToDeletedDate>2008/11/05</ToDeletedDate>
          </DeletedDateRangeFilter>
        </ListDeletedQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
  shshshshshsh

    Qbxml::Request.new(Quickbooks::Customer, :deleted, :filters => "<FILTERS><ListDelType>Customer</ListDelType><DeletedDateRangeFilter><FromDeletedDate>2008/10/05</FromDeletedDate><ToDeletedDate>2008/11/05</ToDeletedDate></DeletedDateRangeFilter></FILTERS>".formatted(:xml)).to_xml.formatted(:xml).should === deleted.formatted(:xml)
  end

  it "should render a ListDeletedQuery with {filters aliased to nested filter keys} correctly" do
    # DATETIMETYPE == Date#strftime("%Y/%M/%D") || Time#strftime("%Y/%M/%D %H/%m/%s")
    deleted = <<-shshshshshsh
    <QBXML>
      <QBXMLMsgsRq onError='stopOnError'>
        <ListDeletedQueryRq requestID = "7">
          <ListDelType>Customer</ListDelType>
          <DeletedDateRangeFilter>
            <FromDeletedDate>2008/10/05</FromDeletedDate>
            <ToDeletedDate>2008/11/05</ToDeletedDate>
          </DeletedDateRangeFilter>
        </ListDeletedQueryRq>
      </QBXMLMsgsRq>
    </QBXML>
    shshshshshsh

    Qbxml::Request.new(Quickbooks::Customer, :deleted, :deleted_after => '2008/10/05', :deleted_before => '2008/11/05').to_xml.formatted(:xml).should === deleted.formatted(:xml)
  end

  # None of the above tests care about the order of attributes yet.
  it "should be able to order a multi-level hash based on a flat array with slash/separated/heirarchy" do
    map = ['first', 'second/into', 'second/after', 'second/last', 'third', 'fourth', 'fifth/another', 'fifth/nice', 'fifth/day']
    hsh_a = {'second' => {'into' => 'the box', 'last' => 'time'}, 'fourth' => 'night', 'fifth' => {'another' => 'time', 'nice' => 'clothes'}}.slashed
    hsh_b = {'first' => 'man', 'second' => {'after' => 'the first', 'last' => 'forever'}, 'third' => 'day', 'fifth' => {'another' => 'a', 'day' => 'night'}}.slashed
    hsh_a.ordered!(map)
    hsh_a.keys.should == ['second', 'fourth', 'fifth']
    hsh_a['second'].keys.should == ['into', 'last']
    hsh_a['fifth'].keys.should == ['another', 'nice']
    hsh_b.ordered!(map)
    hsh_b.keys.should == ['first', 'second', 'third', 'fifth']
    hsh_b['second'].keys.should == ['after', 'last']
    hsh_b['fifth'].keys.should == ['another', 'day']
  end
end
