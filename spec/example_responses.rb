require 'date'
require 'time'
module Quickbooks
  module ExampleResponses
    SingleCustomerQueryRs = <<-123456789
    <CustomerQueryRs requestID = "UUIDTYPE" statusCode = "INTTYPE" statusSeverity = "STRTYPE" statusMessage = "STRTYPE" retCount = "INTTYPE" iteratorRemainingCount = "INTTYPE" iteratorID = "UUIDTYPE">
      <CustomerRet>
        <ListID>12345</ListID>
        <TimeCreated>#{Time.now.xmlschema}</TimeCreated>
        <TimeModified>#{Time.now.xmlschema}</TimeModified>
        <EditSequence>2348761234</EditSequence>
        <Name>Joe Schmoe</Name>
        <FullName>Schmoe, Joe</FullName>
        <IsActive>true</IsActive>
        <CompanyName>Schmoe's Camping</CompanyName>
        <Salutation>Mr.</Salutation>
        <FirstName>Joe</FirstName>
        <LastName>Schmoe</LastName>
        <Suffix>Jr.</Suffix>
        <BillAddress>
          <Addr1>999 Some Rd</Addr1>
          <City>Other City</City>
          <State>TX</State>
          <PostalCode>88888</PostalCode>
        </BillAddress>
        <Phone>(554) 682-2291</Phone>
        <SalesTaxCodeRef>
          <ListID>2983723</ListID>
          <FullName>foo</FullName>
        </SalesTaxCodeRef>
        <SalesTaxCountry>USA</SalesTaxCountry>
        <CreditLimit>500</CreditLimit>
        <CreditCardInfo>
          <CreditCardNumber>9898-1323-9882-9918</CreditCardNumber>
          <ExpirationMonth>8</ExpirationMonth>
          <ExpirationYear>2010</ExpirationYear>
          <NameOnCard>Joe E. Schmoe</NameOnCard>
          <CreditCardAddress>999 Some Rd, Other City, TX</CreditCardAddress>
          <CreditCardPostalCode>88888</CreditCardPostalCode>
        </CreditCardInfo>
        <Notes>This is a test record, do not consider all values as possible values from Quickbooks.</Notes>
        <DeliveryMethod>Email</DeliveryMethod>
        <DataExtRet>
          <OwnerID>293861</OwnerID>
          <DataExtName>happiness level</DataExtName>
          <DataExtType>INTTYPE</DataExtType>
          <DataExtValue>7</DataExtValue>
        </DataExtRet>
        <DataExtRet>
          <OwnerID>293823</OwnerID>
          <DataExtName>sadness level</DataExtName>
          <DataExtType>INTTYPE</DataExtType>
          <DataExtValue>4</DataExtValue>
        </DataExtRet>
      </CustomerRet>
    </CustomerQueryRs>
    123456789

    MultipleCustomerQueryRs = <<-123456789
    <CustomerQueryRs requestID = "UUIDTYPE" statusCode = "INTTYPE" statusSeverity = "STRTYPE" statusMessage = "STRTYPE" retCount = "INTTYPE" iteratorRemainingCount = "INTTYPE" iteratorID = "UUIDTYPE">
      #{SingleCustomerQueryRs}
      <CustomerRet>
        <ListID>12346</ListID>
        <TimeCreated>#{Time.now.xmlschema}</TimeCreated>
        <TimeModified>#{Time.now.xmlschema}</TimeModified>
        <EditSequence>2348761234</EditSequence>
        <Name>Moe Schmoe</Name>
        <FullName>Schmoe, Moe</FullName>
        <IsActive>true</IsActive>
        <CompanyName>More of Schmoe's Camping</CompanyName>
        <Salutation>Mr.</Salutation>
        <FirstName>Moe</FirstName>
        <LastName>Schmoe</LastName>
        <Suffix>Jr.</Suffix>
        <BillAddress>
          <Addr1>998 Some Rd</Addr1>
          <City>Other City</City>
          <State>TX</State>
          <PostalCode>88888</PostalCode>
        </BillAddress>
        <Phone>(554) 682-2290</Phone>
        <SalesTaxCodeRef>
          <ListID>2983724</ListID>
          <FullName>foo</FullName>
        </SalesTaxCodeRef>
        <SalesTaxCountry>USA</SalesTaxCountry>
        <CreditLimit>500</CreditLimit>
        <CreditCardInfo>
          <CreditCardNumber>9898-1322-9882-9918</CreditCardNumber>
          <ExpirationMonth>8</ExpirationMonth>
          <ExpirationYear>2010</ExpirationYear>
          <NameOnCard>Moe E. Schmoe</NameOnCard>
          <CreditCardAddress>999 Some Rd, Other City, TX</CreditCardAddress>
          <CreditCardPostalCode>88888</CreditCardPostalCode>
        </CreditCardInfo>
        <Notes>This is a test record, do not consider all values as possible values from Quickbooks.</Notes>
        <DeliveryMethod>Email</DeliveryMethod>
        <DataExtRet>
          <OwnerID>293862</OwnerID>
          <DataExtName>happiness level</DataExtName>
          <DataExtType>INTTYPE</DataExtType>
          <DataExtValue>4</DataExtValue>
        </DataExtRet>
        <DataExtRet>
          <OwnerID>293824</OwnerID>
          <DataExtName>sadness level</DataExtName>
          <DataExtType>INTTYPE</DataExtType>
          <DataExtValue>6</DataExtValue>
        </DataExtRet>
      </CustomerRet>
    </CustomerQueryRs>
    123456789

    SalesOrderAddRqA = <<-123456789
    <SalesOrderAddRq requestID = "4">                <!-- not in QBOE, v2.1 -->
      <SalesOrderAdd>
        <CustomerRef>
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 209 for QBD|QBCA|QBUK|QBAU -->
        </CustomerRef>
        <ClassRef>                                          <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
        </ClassRef>
        <TemplateRef>                                       <!-- opt, v3.0 -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
        </TemplateRef>
        <TxnDate>DATETYPE</TxnDate>                         <!-- opt -->
        <RefNumber>STRTYPE</RefNumber>                      <!-- opt, max length = 11 for QBD|QBCA|QBUK|QBAU -->
        <BillAddress>                                       <!-- opt -->
          <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, v2.0 -->
          <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, v6.0 -->
          <City>STRTYPE</City>                              <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          <State>STRTYPE</State>                            <!-- opt, max length = 21 for QBD|QBCA|QBUK|QBAU -->
          <PostalCode>STRTYPE</PostalCode>                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU -->
          <Country>STRTYPE</Country>                        <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          <Note>STRTYPE</Note>                              <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, v6.0 -->
        </BillAddress>
        <ShipAddress>                                       <!-- opt -->
          <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, v2.0 -->
          <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, v6.0 -->
          <City>STRTYPE</City>                              <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          <State>STRTYPE</State>                            <!-- opt, max length = 21 for QBD|QBCA|QBUK|QBAU -->
          <PostalCode>STRTYPE</PostalCode>                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU -->
          <Country>STRTYPE</Country>                        <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          <Note>STRTYPE</Note>                              <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU, v6.0 -->
        </ShipAddress>
        <PONumber>STRTYPE</PONumber>                        <!-- opt, max length = 25 for QBD|QBCA|QBUK|QBAU -->
        <TermsRef>                                          <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
        </TermsRef>
        <DueDate>DATETYPE</DueDate>                         <!-- opt -->
        <SalesRepRef>                                       <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 5 for QBD|QBCA|QBUK|QBAU -->
        </SalesRepRef>
        <FOB>STRTYPE</FOB>                                  <!-- opt, max length = 13 for QBD|QBCA|QBUK|QBAU -->
        <ShipDate>DATETYPE</ShipDate>                       <!-- opt -->
        <ShipMethodRef>                                     <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 15 for QBD|QBCA|QBUK|QBAU -->
        </ShipMethodRef>
        <ItemSalesTaxRef>                                   <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
        </ItemSalesTaxRef>
        <IsManuallyClosed>BOOLTYPE</IsManuallyClosed>       <!-- opt -->
        <Memo>STRTYPE</Memo>                                <!-- opt, max length = 4095 for QBD|QBCA|QBUK|QBAU -->
        <CustomerMsgRef>                                    <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 101 for QBD|QBCA|QBUK|QBAU -->
        </CustomerMsgRef>
        <IsToBePrinted>BOOLTYPE</IsToBePrinted>             <!-- opt -->
        <IsToBeEmailed>BOOLTYPE</IsToBeEmailed>             <!-- opt, v6.0 -->
        <IsTaxIncluded>BOOLTYPE</IsTaxIncluded>             <!-- opt, not in QBD, v6.0 -->
        <CustomerSalesTaxCodeRef>                           <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 3 for QBD|QBCA|QBUK, max length = 6 for QBAU -->
        </CustomerSalesTaxCodeRef>
        <Other>STRTYPE</Other>                              <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
        <!-- BEGIN OR: You may have 1 or more SalesOrderLineAdd OR SalesOrderLineGroupAdd -->
        <SalesOrderLineAdd>
          <ItemRef>                                         <!-- opt -->
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt -->
          </ItemRef>
          <Desc>STRTYPE</Desc>                              <!-- opt, max length = 4095 for QBD|QBCA|QBUK|QBAU -->
          <Quantity>QUANTYPE</Quantity>                     <!-- opt -->
          <UnitOfMeasure>STRTYPE</UnitOfMeasure>            <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, v7.0 -->
          <!-- BEGIN OR: You may optionally have Rate OR RatePercent OR PriceLevelRef -->
          <Rate>PRICETYPE</Rate>
          <!-- OR -->
          <RatePercent>PERCENTTYPE</RatePercent>
          <!-- OR -->
          <PriceLevelRef>                                   <!-- v4.0 -->
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          </PriceLevelRef>
          <!-- END OR -->
          <ClassRef>                                        <!-- opt -->
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt, max length = 159 for QBD|QBCA|QBUK|QBAU -->
          </ClassRef>
          <Amount>AMTTYPE</Amount>                          <!-- opt -->
          <SalesTaxCodeRef>                                 <!-- opt -->
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt, max length = 3 for QBD|QBCA|QBUK, max length = 6 for QBAU -->
          </SalesTaxCodeRef>
          <IsManuallyClosed>BOOLTYPE</IsManuallyClosed>     <!-- opt -->
          <Other1>STRTYPE</Other1>                          <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
          <Other2>STRTYPE</Other2>                          <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
          <DataExt>                                         <!-- opt, may rep, v5.0 -->
            <OwnerID>GUIDTYPE</OwnerID>
            <DataExtName>STRTYPE</DataExtName>              <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
            <DataExtValue>STRTYPE</DataExtValue>
          </DataExt>
        </SalesOrderLineAdd>
        <!-- OR -->
        <SalesOrderLineGroupAdd>
          <ItemGroupRef>
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          </ItemGroupRef>
          <Desc>STRTYPE</Desc>                              <!-- opt, not in QBD|QBCA|QBUK|QBAU -->
          <Quantity>QUANTYPE</Quantity>                     <!-- opt -->
          <UnitOfMeasure>STRTYPE</UnitOfMeasure>            <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, v7.0 -->
          <DataExt>                                         <!-- opt, may rep, v5.0 -->
            <OwnerID>GUIDTYPE</OwnerID>
            <DataExtName>STRTYPE</DataExtName>              <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
            <DataExtValue>STRTYPE</DataExtValue>
          </DataExt>
        </SalesOrderLineGroupAdd>
        <!-- END OR -->
      </SalesOrderAdd>
      <IncludeRetElement>STRTYPE</IncludeRetElement>        <!-- opt, may rep, max length = 50 for QBD|QBCA|QBUK|QBAU, v4.0 -->
    </SalesOrderAddRq>
    123456789
    
  end
end