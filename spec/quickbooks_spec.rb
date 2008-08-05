require File.dirname(__FILE__) + '/spec_helper'

describe "quickbooks" do
  it "should use the test adapter and send test xml" do
    Quickbooks::Base.use_adapter(:test)
    Quickbooks::Base.establish_connection
  end

  it "should generate a Customer query request" do
    Quickbooks::Base.connection.next_response(Quickbooks::ExampleResponses::MultipleCustomerQueryRs) do |request_xml|
      # Now test request_xml to be correct. Should look something like this:
      # <?xml version="1.0" ?>
      # <?qbxml version="0.4.4" ?>
      # <QBXML>
      # <QBXMLMsgsRq onError="stopOnError">
      # <CustomerQueryRq requestID="1">
      #   <ActiveStatus>All</ActiveStatus>
      # </CustomerQueryRq>
      # </QBXMLMsgsRq>
      # </QBXML>
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
      # Test request_xml to be correct. Should look something like this:
      # <?xml version="1.0" ?>
      # <?qbxml version="0.4.4" ?>
      # <QBXML>
      # <QBXMLMsgsRq onError="stopOnError">
      # <CustomerQueryRq requestID="2">
      #   <MaxReturned>1</MaxReturned>
      # </CustomerQueryRq>
      # </QBXMLMsgsRq>
      # </QBXML>
      request = request_xml.formatted(:xml).to_hash
      request.should have_key('QBXML')
      request['QBXML'].should have_key('QBXMLMsgsRq')
      request['QBXML']['QBXMLMsgsRq'].should have_key('CustomerQueryRq')
      request['QBXML']['QBXMLMsgsRq']['CustomerQueryRq']['MaxReturned'].should eql('1')
    end

    j = Quickbooks::Customer.first
    j.last_name.value.should eql('Schmoe')
    j.bill_address.state.value.should eql('TX')
    # j.data_exts.length.should eql(2)
  end
end


# To test:
# 1) Open the RSpec Test Company.QBW file in quickbooks.
# 2) Password is 'test'
# 3) Run the tests:
#       spec specs\quickbooks_spec.rb
# (on Windows, you may need to 'gem install rspec'.
#   If you don't have the 'gem' command, try installing
#   Ruby via the One-Click Ruby Installer for Windows.)
# describe "quickbooks" do
#   it "should connect to the current active quickbooks file" do
#     pending
#     Quickbooks::Base.establish_connection
#     Quickbooks::Base.connection.send(:connect)
#   end
# 
#   it "should create a session" do
#     pending
#     Quickbooks::Base.connection.begin_session
#   end
# 
#   it "should perform an example qbXML query" do
#     pending
#     xml = <<-EOL
# <?xml version="1.0" ?>
# <?qbxml version="5.0" ?>
# <QBXML>
#   <QBXMLMsgsRq onError="stopOnError">
#     <CustomerQueryRq requestID="4997">
#       <IncludeRetElement>ListID</IncludeRetElement>
#     </CustomerQueryRq>
#   </QBXMLMsgsRq>
# </QBXML>
# EOL
#     Quickbooks::Base.connection.send_xml(xml)
#   end
# 
#   it "should gather all clients" do
#     pending
#     Quickbooks::Customer.all
#   end
# 
#   it "should grab the first client" do
#     pending
#     j = Quickbooks::Customer.first
#     j.last_name.should eql('Doe')
#   end
# 
#   it "should instantiate objects into the class they should be" do
#     pending
#     Quickbooks::Customer.first.should be_is_a(Quickbooks::Customer)
#   end
# 
#   it "should update the first client's phone number" do
#     pending
#     j = Quickbooks::Customer.first
#     old_phone = j.phone
#     new_phone = '523-998-8821'
#     j.phone = new_phone
#     j.save
#     j.reload
#     j.phone.should eql(new_phone)
#   end
# 
#   it "should respect changes made by other people when updating a record, if they don't update the same attributes" do
#     pending
#     j = Quickbooks::Customer.first
#     k = Quickbooks::Customer.first
#     j.phone = (['222-093-8443', '828-981-0092'] - [j.phone])[0]
#     j.save
#     k.salutation = (['Jr.', 'Mr.'] - [k.salutation])[0]
#     k.save
#     k.phone.should_not eql(j.phone)
#     k.original_values['phone'].should eql(j.phone)
#     j.reload
#     k.edit_sequence.should eql(j.edit_sequence)
#   end
# 
#   it "should update with changes made by other people, but still save changes, if the record has no conflicts" do
#     pending
#     j = Quickbooks::Customer.first
#     k = Quickbooks::Customer.first
#     # Set up some values
#     jphone = (['222-093-8443', '828-981-0092'] - [k.phone])[0]
#     ksal = (['Jr.', 'Mr.'] - [k.salutation])[0]
#     # Set the values: j only gets the phone, but j gets phone and new salutation.
#     j.phone = jphone
#     k.phone = jphone
#     k.salutation = ksal
#     # Should succeed saving...
#     j.save.should eql(true)
#     k.save.should eql(true)
#     j.reload
#     # If they save correctly, both phone and salutation will be updated without a problem.
#     j.salutation.should eql(ksal)
#     k.salutation.should eql(ksal)
#     j.phone.should eql(k.phone)
#   end
# 
#   it "should not save anything, and leave you with a dirty object, if the record has conflicts" do
#     pending
#     j = Quickbooks::Customer.first
#     k = Quickbooks::Customer.first
#     # Set up some values
#     jphone = (['222-093-8443', '828-981-0092'] - [j.phone])[0]
#     kphone = (['022-093-8443', '028-981-0092'] - [k.phone])[0]
#     prev_ksal = k.salutation
#     ksal = (['Jr.', 'Mr.'] - [k.salutation])[0]
#     # Set the values: j only gets the phone, but j gets phone and new salutation.
#     j.phone = jphone
#     k.phone = kphone # conflicts with jphone
#     k.salutation = ksal
#     # Should succeed saving...
#     j.save.should eql(true)
#     # Should return false, but should have saved the salutation
#     k.save.should eql(false)
#     j.reload
#     # j reflects the database and is not dirty
#     j.phone.should eql(jphone)
#     j.salutation.should eql(prev_ksal)
#     # k's original_attributes should equal j's attributes, but k should be dirtied by its own phone number
#     k.phone.should eql(kphone)
#     k.salutation.should eql(ksal)
#     k.original_values['salutation'].should eql(prev_ksal)
#     k.original_values['phone'].should eql(jphone)
#     k.should be_dirty
#   end
# 
#   it "should add a client" do
#     pending
#     j = Quickbooks::Customer.new(:name => 'Graham Roosevelt')
#     j.save
#     j.list_id.should_not be_nil
#   end
# 
#   it "should find a client by name" do
#     pending
#     j = Quickbooks::Customer.first(:FullName => 'Graham Roosevelt')
#     j.full_name.should eql('Graham Roosevelt')
#   end
# 
#   it "should destroy a client" do
#     pending
#     j = Quickbooks::Customer.first(:FullName => 'Graham Roosevelt')
#     j.destroy.should eql(true)
#   end
# end
