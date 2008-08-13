require 'quickbooks/entity'
require 'quickbooks/properties/name'
require 'quickbooks/properties/is_active'
require 'quickbooks/refs/parent_ref'
require 'quickbooks/properties/company_name'
require 'quickbooks/properties/salutation'
require 'quickbooks/properties/first_name'
require 'quickbooks/properties/middle_name'
require 'quickbooks/properties/last_name'
require 'quickbooks/properties/suffix'
require 'quickbooks/entities/bill_address'
require 'quickbooks/entities/ship_address'
require 'quickbooks/properties/print_as'
require 'quickbooks/properties/phone'
require 'quickbooks/properties/mobile'
require 'quickbooks/properties/pager'
require 'quickbooks/properties/alt_phone'
require 'quickbooks/properties/fax'
require 'quickbooks/properties/email'
require 'quickbooks/properties/contact'
require 'quickbooks/properties/alt_contact'
require 'quickbooks/refs/customer_type_ref'
require 'quickbooks/refs/terms_ref'
require 'quickbooks/refs/sales_rep_ref'
require 'quickbooks/properties/open_balance'
require 'quickbooks/properties/open_balance_date'
require 'quickbooks/refs/sales_tax_code_ref'
require 'quickbooks/refs/item_sales_tax_ref'
require 'quickbooks/properties/sales_tax_country'
require 'quickbooks/properties/resale_number'
require 'quickbooks/properties/account_number'
require 'quickbooks/properties/credit_limit'
require 'quickbooks/refs/preferred_payment_method_ref'
require 'quickbooks/entities/credit_card_info'
require 'quickbooks/properties/job_status'
require 'quickbooks/properties/job_start_date'
require 'quickbooks/properties/job_projected_end_date'
require 'quickbooks/properties/job_end_date'
require 'quickbooks/properties/job_desc'
require 'quickbooks/refs/job_type_ref'
require 'quickbooks/properties/notes'
require 'quickbooks/properties/is_statement_with_parent'
require 'quickbooks/properties/delivery_method'
require 'quickbooks/refs/price_level_ref'
require 'quickbooks/embedded_entities/data_ext'

module Quickbooks
  class Customer < ListItem
    self.valid_filters = ['active_status', 'from_modified_date', 'to_modified_date', 'name_filter', 'name_range_filter', 'total_balance_filter']

    properties Name[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU], 100 => :QBOE}],
               IsActive[:not_in => :QBOE],
               ParentRef,
               CompanyName[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU], 50 => :QBOE}],
               Salutation[:max_length => 15],
               FirstName[:max_length => 25],
               MiddleName[:max_length => {5 => [:QBD, :QBCA, :QBUK, :QBAU], 25 => :QBOE}],
               LastName[:max_length => 25],
               Suffix[:max_length => {10 => :QBOE}, :not_in => [:QBD, :QBCA, :QBUK, :QBAU]],
               BillAddress,
               ShipAddress,
               PrintAs[:max_length => {110 => :QBOE}, :not_in => [:QBD, :QBCA, :QBUK, :QBAU]],
               Phone[:max_length => 21],
               Mobile[:max_length => {21 => :QBOE}, :not_in => [:QBD, :QBCA, :QBUK, :QBAU]],
               Pager[:max_length => {21 => :QBOE}, :not_in => [:QBD, :QBCA, :QBUK, :QBAU]],
               AltPhone[:max_length => 21],
               Fax[:max_length => 21],
               Email[:max_length => {1023 => [:QBD, :QBCA, :QBUK, :QBAU], 100 => :QBOE}],
               Contact[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => :QBOE],
               AltContact[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => :QBOE],
               CustomerTypeRef[:not_in => :QBOE],
               TermsRef,
               SalesRepRef[:not_in => :QBOE],
               OpenBalance[:actions => :add],
               OpenBalanceDate[:actions => :add],
               SalesTaxCodeRef[:not_in => :QBOE],
               ItemSalesTaxRef[:not_in => :QBOE],
               SalesTaxCountry[:max_length => {31 => [:QBCA, :QBUK, :QBAU]}, :not_in => [:QBD, :QBOE, 6.0]],
               ResaleNumber[:max_length => {15 => :QBD, 21 => [:QBCA, :QBUK, :QBAU], 16 => :QBOE}],
               AccountNumber[:max_length => {99 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => :QBOE],
               CreditLimit[:not_in => :QBOE],
               PreferredPaymentMethodRef[:not_in => [:QBOE, 3.0]],
               CreditCardInfo[:not_in => [:QBOE, 3.0]],
               JobStatus[:not_in => :QBOE],
               JobStartDate[:not_in => :QBOE],
               JobProjectedEndDate[:not_in => :QBOE],
               JobEndDate[:not_in => :QBOE],
               JobDesc[:max_length => {99 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => :QBOE],
               JobTypeRef[:not_in => :QBOE],
               Notes[:max_length => {4095 => [:QBD, :QBCA, :QBUK, :QBAU]}, :not_in => [:QBOE, 3.0]],
               IsStatementWithParent[:not_in => [:QBD, :QBCA, :QBUK, :QBAU]],
               DeliveryMethod[:not_in => [:QBD, :QBCA, :QBUK, :QBAU]],
               PriceLevelRef[:not_in => [:QBOE, 4.0]],
               DataExts[:not_in => [:QBOE, 2.0]]
  end
end

# <!-- CustomerAddRq contains 1 optional attribute: 'requestID' -->
# <CustomerAddRq requestID = "UUIDTYPE">
#   <CustomerAdd>
#     <Name>STRTYPE</Name>                                <!-- max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 100 for QBOE -->
#     <IsActive>BOOLTYPE</IsActive>                       <!-- opt, not in QBOE -->
#     <ParentRef>                                         <!-- opt -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt -->
#     </ParentRef>
#     <CompanyName>STRTYPE</CompanyName>                  <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 50 for QBOE -->
#     <Salutation>STRTYPE</Salutation>                    <!-- opt, max length = 15 -->
#     <FirstName>STRTYPE</FirstName>                      <!-- opt, max length = 25 -->
#     <MiddleName>STRTYPE</MiddleName>                    <!-- opt, max length = 5 for QBD|QBCA|QBUK|QBAU, max length = 25 for QBOE -->
#     <LastName>STRTYPE</LastName>                        <!-- opt, max length = 25 -->
#     <Suffix>STRTYPE</Suffix>                            <!-- opt, max length = 10 for QBOE, not in QBD|QBCA|QBUK|QBAU -->
#     <BillAddress>                                       <!-- opt -->
#       <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#       <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#       <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#       <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE, v2.0 -->
#       <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
#       <City>STRTYPE</City>                              <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#       <State>STRTYPE</State>                            <!-- opt, max length = 21 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#       <PostalCode>STRTYPE</PostalCode>                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU, max length = 30 for QBOE -->
#       <Country>STRTYPE</Country>                        <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#       <Note>STRTYPE</Note>                              <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
#     </BillAddress>
#     <ShipAddress>                                       <!-- opt -->
#       <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#       <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#       <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE -->
#       <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, max length = 500 for QBOE, v2.0 -->
#       <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
#       <City>STRTYPE</City>                              <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#       <State>STRTYPE</State>                            <!-- opt, max length = 21 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#       <PostalCode>STRTYPE</PostalCode>                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU, max length = 30 for QBOE -->
#       <Country>STRTYPE</Country>                        <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 255 for QBOE -->
#       <Note>STRTYPE</Note>                              <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE, v6.0 -->
#     </ShipAddress>
#     <PrintAs>STRTYPE</PrintAs>                          <!-- opt, max length = 110 for QBOE, not in QBD|QBCA|QBUK|QBAU -->
#     <Phone>STRTYPE</Phone>                              <!-- opt, max length = 21 -->
#     <Mobile>STRTYPE</Mobile>                            <!-- opt, max length = 21 for QBOE, not in QBD|QBCA|QBUK|QBAU -->
#     <Pager>STRTYPE</Pager>                              <!-- opt, max length = 21 for QBOE, not in QBD|QBCA|QBUK|QBAU -->
#     <AltPhone>STRTYPE</AltPhone>                        <!-- opt, max length = 21 -->
#     <Fax>STRTYPE</Fax>                                  <!-- opt, max length = 21 -->
#     <Email>STRTYPE</Email>                              <!-- opt, max length = 1023 for QBD|QBCA|QBUK|QBAU, max length = 100 for QBOE -->
#     <Contact>STRTYPE</Contact>                          <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE -->
#     <AltContact>STRTYPE</AltContact>                    <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, not in QBOE -->
#     <CustomerTypeRef>                                   <!-- opt, not in QBOE -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
#     </CustomerTypeRef>
#     <TermsRef>                                          <!-- opt -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, max length = 100 for QBOE -->
#     </TermsRef>
#     <SalesRepRef>                                       <!-- opt, not in QBOE -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 5 for QBD|QBCA|QBUK|QBAU -->
#     </SalesRepRef>
#     <OpenBalance>AMTTYPE</OpenBalance>                  <!-- opt -->
#     <OpenBalanceDate>DATETYPE</OpenBalanceDate>         <!-- opt -->
#     <SalesTaxCodeRef>                                   <!-- opt, not in QBOE -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 3 for QBD|QBCA|QBUK, max length = 6 for QBAU -->
#     </SalesTaxCodeRef>
#     <ItemSalesTaxRef>                                   <!-- opt, not in QBOE -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
#     </ItemSalesTaxRef>
#     <SalesTaxCountry>STRTYPE</SalesTaxCountry>          <!-- opt, max length = 31 for QBCA|QBUK|QBAU, not in QBD|QBOE, v6.0 -->
#     <ResaleNumber>STRTYPE</ResaleNumber>                <!-- opt, max length = 15 for QBD, max length = 21 for QBCA|QBUK|QBAU, max length = 16 for QBOE -->
#     <AccountNumber>STRTYPE</AccountNumber>              <!-- opt, max length = 99 for QBD|QBCA|QBUK|QBAU, not in QBOE -->
#     <CreditLimit>AMTTYPE</CreditLimit>                  <!-- opt, not in QBOE -->
#     <PreferredPaymentMethodRef>                         <!-- opt, not in QBOE, v3.0 -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
#     </PreferredPaymentMethodRef>
#     <CreditCardInfo>                                    <!-- opt, not in QBOE, v3.0 -->
#       <CreditCardNumber>STRTYPE</CreditCardNumber>      <!-- opt, max length = 25 for QBD|QBCA|QBUK|QBAU -->
#       <ExpirationMonth>INTTYPE</ExpirationMonth>        <!-- opt, min value = 1, max value = 12 -->
#       <ExpirationYear>INTTYPE</ExpirationYear>          <!-- opt -->
#       <NameOnCard>STRTYPE</NameOnCard>                  <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#       <CreditCardAddress>STRTYPE</CreditCardAddress>    <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#       <CreditCardPostalCode>STRTYPE</CreditCardPostalCode> <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#     </CreditCardInfo>
#     <!-- JobStatus may have one of the following values: Awarded, Closed, InProgress, None [DEFAULT], NotAwarded, Pending -->
#     <JobStatus>ENUMTYPE</JobStatus>                     <!-- opt, not in QBOE -->
#     <JobStartDate>DATETYPE</JobStartDate>               <!-- opt, not in QBOE -->
#     <JobProjectedEndDate>DATETYPE</JobProjectedEndDate> <!-- opt, not in QBOE -->
#     <JobEndDate>DATETYPE</JobEndDate>                   <!-- opt, not in QBOE -->
#     <JobDesc>STRTYPE</JobDesc>                          <!-- opt, max length = 99 for QBD|QBCA|QBUK|QBAU, not in QBOE -->
#     <JobTypeRef>                                        <!-- opt, not in QBOE -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
#     </JobTypeRef>
#     <Notes>STRTYPE</Notes>                              <!-- opt, max length = 4095 for QBD|QBCA|QBUK|QBAU, not in QBOE, v3.0 -->
#     <IsStatementWithParent>BOOLTYPE</IsStatementWithParent> <!-- opt, not in QBD|QBCA|QBUK|QBAU -->
#     <!-- DeliveryMethod may have one of the following values: Email, Fax, Print [DEFAULT] -->
#     <DeliveryMethod>ENUMTYPE</DeliveryMethod>           <!-- opt, not in QBD|QBCA|QBUK|QBAU -->
#     <PriceLevelRef>                                     <!-- opt, not in QBOE, v4.0 -->
#       <ListID>IDTYPE</ListID>                           <!-- opt -->
#       <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
#     </PriceLevelRef>
#   </CustomerAdd>
#   <IncludeRetElement>STRTYPE</IncludeRetElement>        <!-- opt, may rep, max length = 50 for QBD|QBCA|QBUK|QBAU, not in QBOE, v4.0 -->
# </CustomerAddRq>
