require File.dirname(__FILE__) + '/spec_helper'

describe Quickbooks do
  # This should be a before(:all) or something...
  before :all do
    Quickbooks::Base.use_adapter(:test)
    Quickbooks::Base.establish_connection
  end

  it "should generate a Customer query request" do
    Quickbooks::Base.connection.next_response(Quickbooks::ExampleResponses::MultipleCustomerQueryRs) do |request_xml|
      request = request_xml.formatted(:xml).to_hash
      request.should have_key('QBXML')
      request['QBXML'].should have_key('QBXMLMsgsRq')
      request['QBXML']['QBXMLMsgsRq'].should have_key('CustomerQueryRq')
      request['QBXML']['QBXMLMsgsRq']['CustomerQueryRq']['ActiveStatus'].should eql('All')
    end
    Quickbooks::Customer.all
  end

  it "should grab the first client" do
    Quickbooks::Base.connection.next_response(Quickbooks::ExampleResponses::SingleCustomerQueryRs) do |request_xml|
      request = request_xml.formatted(:xml).to_hash
      request.should have_key('QBXML')
      request['QBXML'].should have_key('QBXMLMsgsRq')
      request['QBXML']['QBXMLMsgsRq'].should have_key('CustomerQueryRq')
      request['QBXML']['QBXMLMsgsRq']['CustomerQueryRq']['MaxReturned'].should eql('1')
    end

    j = Quickbooks::Customer.first
    j.last_name.should eql('Schmoe')
    j.bill_address.state.should eql('TX')
  end

  it "should remember sample responses (test adapter)" do
    Quickbooks::Customer.first.should be_is_a(Quickbooks::Customer)
    Quickbooks::Customer.all.length.should eql(2)
  end

  it "should assign a *_ref property" do
    joe = Quickbooks::Customer.first
    joe.to_ref.class.name.should eql('Quickbooks::CustomerRef')
    so = Quickbooks::SalesOrder.new(:customer => joe.to_ref)
    so.customer.class.name.should eql('Quickbooks::CustomerRef')
    so = Quickbooks::SalesOrder.new(:customer => joe, :txn_date => Date.today)
    so.customer.class.name.should eql('Quickbooks::CustomerRef')
    so.customer.should === joe
  end

  it "should operate internal associations with embedded entities" do
    j = Quickbooks::Customer.first
    j.should be_respond_to(:data_ext_ret=)
    j.data_exts.length.should eql(2)
  end

  it "should create a correct Add request containing an EmbeddedEntity" do
    # pending "TODO - Embedded Entities - to xml"
    joe = Quickbooks::Customer.first
    # puts "Joe: #{joe} / #{joe.to_ref}"
    so = Quickbooks::SalesOrder.new(:customer => joe, :txn_date => Time.now)
    so.should be_new_record
    so.should be_dirty
    so.should be_respond_to(:customer)
    so.customer.class.name.should eql('Quickbooks::CustomerRef')
    so.customer.should == joe.to_ref
    so.customer.should === joe
    so.customer.should be_dirty
    so.customer.dirty_attributes.should have_key('list_id')
    so.customer.dirty_attributes({}, true).should have_key('ListID')
    Quickbooks::Base.connection.next_response(Quickbooks::ExampleResponses::SalesOrderAddRsA) do |request_xml|
      request_xml.formatted(:xml).to_hash['QBXML']['QBXMLMsgsRq']['SalesOrderAddRq']['SalesOrderAdd'].should have_key('TxnDate')
      request_xml.formatted(:xml).to_hash['QBXML']['QBXMLMsgsRq']['SalesOrderAddRq']['SalesOrderAdd'].should have_key('CustomerRef')
      request_xml.formatted(:xml).to_hash['QBXML']['QBXMLMsgsRq']['SalesOrderAddRq']['SalesOrderAdd']['CustomerRef'].should have_key('ListID')
    end
    so.save
  end

  it "should instantiate an EmbeddedEntity correctly from XML" do
    so = Qbxml::ResponseSet.new(Quickbooks::ExampleResponses::SalesOrderAddRsA).collect {|response| response.instantiate()}.flatten[0]
    so.should be_is_a(Quickbooks::SalesOrder)
    so.txn_id.should eql(98769876)
    so.customer.should === Quickbooks::Customer.first
    so.sales_order_lines.length.should eql(2)
    so.sales_order_lines[0].should be_is_a(Quickbooks::SalesOrderLine)
    so.sales_order_lines[1].item.list_id.should eql(8887779)
  end

  it "should request an Entity containing an EmbeddedEntity, modify it, generate a correct Mod request for the EmbeddedEntity, and properly handle the Mod response" do
    Quickbooks::Base.connection.next_response(Quickbooks::ExampleResponses::SalesOrderQueryRsA) do |request_xml|
      request_xml.should eql(Quickbooks::ExampleResponses::SalesOrderQueryRqA)
    end
    $debug = true
    so = Quickbooks::SalesOrder.first(:txn_id => 98769876)
    $debug = false
    # This doesn't work right because it doesn't end in *Ret. I guess we can't count on that... Might have to put in a stronger propety mapping to what the property can be named in return XMLs.
    # I think I'll put this off until I map out the entire qbxmlops70.xml... d(:^P)
    puts so.linked_txns.inspect
  end

  # it "should update the first client's phone number" do
  #   pending
  #   j = Quickbooks::Customer.first
  #   old_phone = j.phone
  #   new_phone = '523-998-8821'
  #   j.phone = new_phone
  #   j.save
  #   j.reload
  #   j.phone.should eql(new_phone)
  # end
  # 
  # it "should respect changes made by other people when updating a record, if they don't update the same attributes" do
  #   pending
  #   j = Quickbooks::Customer.first
  #   k = Quickbooks::Customer.first
  #   j.phone = (['222-093-8443', '828-981-0092'] - [j.phone])[0]
  #   j.save
  #   k.salutation = (['Jr.', 'Mr.'] - [k.salutation])[0]
  #   k.save
  #   k.phone.should_not eql(j.phone)
  #   k.original_values['phone'].should eql(j.phone)
  #   j.reload
  #   k.edit_sequence.should eql(j.edit_sequence)
  # end
  # 
  # it "should update with changes made by other people, but still save changes, if the record has no conflicts" do
  #   pending
  #   j = Quickbooks::Customer.first
  #   k = Quickbooks::Customer.first
  #   # Set up some values
  #   jphone = (['222-093-8443', '828-981-0092'] - [k.phone])[0]
  #   ksal = (['Jr.', 'Mr.'] - [k.salutation])[0]
  #   # Set the values: j only gets the phone, but j gets phone and new salutation.
  #   j.phone = jphone
  #   k.phone = jphone
  #   k.salutation = ksal
  #   # Should succeed saving...
  #   j.save.should eql(true)
  #   k.save.should eql(true)
  #   j.reload
  #   # If they save correctly, both phone and salutation will be updated without a problem.
  #   j.salutation.should eql(ksal)
  #   k.salutation.should eql(ksal)
  #   j.phone.should eql(k.phone)
  # end
  # 
  # it "should not save anything, and leave you with a dirty object, if the record has conflicts" do
  #   pending
  #   j = Quickbooks::Customer.first
  #   k = Quickbooks::Customer.first
  #   # Set up some values
  #   jphone = (['222-093-8443', '828-981-0092'] - [j.phone])[0]
  #   kphone = (['022-093-8443', '028-981-0092'] - [k.phone])[0]
  #   prev_ksal = k.salutation
  #   ksal = (['Jr.', 'Mr.'] - [k.salutation])[0]
  #   # Set the values: j only gets the phone, but j gets phone and new salutation.
  #   j.phone = jphone
  #   k.phone = kphone # conflicts with jphone
  #   k.salutation = ksal
  #   # Should succeed saving...
  #   j.save.should eql(true)
  #   # Should return false, but should have saved the salutation
  #   k.save.should eql(false)
  #   j.reload
  #   # j reflects the database and is not dirty
  #   j.phone.should eql(jphone)
  #   j.salutation.should eql(prev_ksal)
  #   # k's original_attributes should equal j's attributes, but k should be dirtied by its own phone number
  #   k.phone.should eql(kphone)
  #   k.salutation.should eql(ksal)
  #   k.original_values['salutation'].should eql(prev_ksal)
  #   k.original_values['phone'].should eql(jphone)
  #   k.should be_dirty
  # end
  # 
  # it "should add a client" do
  #   pending
  #   j = Quickbooks::Customer.new(:name => 'Graham Roosevelt')
  #   j.save
  #   j.list_id.should_not be_nil
  # end
  # 
  # it "should find a client by name" do
  #   pending
  #   j = Quickbooks::Customer.first(:FullName => 'Graham Roosevelt')
  #   j.full_name.should eql('Graham Roosevelt')
  # end
  # 
  # it "should destroy a client" do
  #   pending
  #   j = Quickbooks::Customer.first(:FullName => 'Graham Roosevelt')
  #   j.destroy.should eql(true)
  # end
end
