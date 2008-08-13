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
    <CustomerQueryRs>
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

    SalesOrderQueryRqA = <<-123456789
<?xml version="1.0" ?>
<?qbxml version="0.4.4" ?>
<QBXML>
<QBXMLMsgsRq onError="stopOnError">
<SalesOrderQueryRq>
  <TxnID>98769876</TxnID>
</SalesOrderQueryRq>
</QBXMLMsgsRq>
</QBXML>
123456789

    SalesOrderQueryRsA = <<-123456789
    <!-- SalesOrderQueryRs contains 7 attributes -->
    <!--    'requestID' is optional -->
    <!--    'statusCode' is required -->
    <!--    'statusSeverity' is required -->
    <!--    'statusMessage' is optional -->
    <!--    'retCount' is optional -->
    <!--    'iteratorRemainingCount' is optional -->
    <!--    'iteratorID' is optional -->
    <SalesOrderQueryRs requestID = "UUIDTYPE" statusCode = "INTTYPE" statusSeverity = "STRTYPE" statusMessage = "STRTYPE" retCount = "INTTYPE" iteratorRemainingCount = "INTTYPE" iteratorID = "UUIDTYPE"> <!-- not in QBOE, v2.1 -->
      <SalesOrderRet>                                       <!-- opt, may rep -->
        <TxnID>IDTYPE</TxnID>
        <TimeCreated>DATETIMETYPE</TimeCreated>
        <TimeModified>DATETIMETYPE</TimeModified>
        <EditSequence>STRTYPE</EditSequence>                <!-- max length = 16 for QBD|QBCA|QBUK|QBAU -->
        <TxnNumber>INTTYPE</TxnNumber>                      <!-- opt -->
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
        <TxnDate>DATETYPE</TxnDate>
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
        <BillAddressBlock>                                  <!-- opt, v6.0 -->
          <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
        </BillAddressBlock>
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
        <ShipAddressBlock>                                  <!-- opt, v6.0 -->
          <Addr1>STRTYPE</Addr1>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr2>STRTYPE</Addr2>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr3>STRTYPE</Addr3>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr4>STRTYPE</Addr4>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
          <Addr5>STRTYPE</Addr5>                            <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
        </ShipAddressBlock>
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
        <Subtotal>AMTTYPE</Subtotal>                        <!-- opt -->
        <ItemSalesTaxRef>                                   <!-- opt -->
          <ListID>IDTYPE</ListID>                           <!-- opt -->
          <FullName>STRTYPE</FullName>                      <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
        </ItemSalesTaxRef>
        <SalesTaxPercentage>PERCENTTYPE</SalesTaxPercentage> <!-- opt -->
        <SalesTaxTotal>AMTTYPE</SalesTaxTotal>              <!-- opt -->
        <TotalAmount>AMTTYPE</TotalAmount>                  <!-- opt -->
        <IsManuallyClosed>BOOLTYPE</IsManuallyClosed>       <!-- opt -->
        <IsFullyInvoiced>BOOLTYPE</IsFullyInvoiced>         <!-- opt -->
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
        <LinkedTxn>                                         <!-- opt, may rep -->
          <TxnID>IDTYPE</TxnID>
          <!-- TxnType may have one of the following values: ARRefundCreditCard, Bill, BillPaymentCheck, BillPaymentCreditCard, BuildAssembly, Charge, Check, CreditCardCharge, CreditCardCredit, CreditMemo, Deposit, Estimate, InventoryAdjustment, Invoice, ItemReceipt, JournalEntry, LiabilityAdjustment, Paycheck, PayrollLiabilityCheck, PurchaseOrder, ReceivePayment, SalesOrder, SalesReceipt, SalesTaxPaymentCheck, Transfer, VendorCredit, YTDAdjustment -->
          <TxnType>ENUMTYPE</TxnType>
          <TxnDate>DATETYPE</TxnDate>
          <RefNumber>STRTYPE</RefNumber>                    <!-- opt, max length = 20 for QBD|QBCA|QBUK|QBAU -->
          <!-- LinkType may have one of the following values: AMTTYPE, QUANTYPE -->
          <LinkType>ENUMTYPE</LinkType>                     <!-- opt, v3.0 -->
          <Amount>AMTTYPE</Amount>
          <TxnLineDetail>                                   <!-- opt, may rep, not in QBD|QBCA|QBUK|QBAU -->
            <TxnLineID>IDTYPE</TxnLineID>
            <Amount>AMTTYPE</Amount>
          </TxnLineDetail>
        </LinkedTxn>
        <SalesOrderLineRet>
          <TxnLineID>IDTYPE</TxnLineID>
          <ItemRef>                                         <!-- opt -->
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt -->
          </ItemRef>
          <Desc>STRTYPE</Desc>                              <!-- opt, max length = 4095 for QBD|QBCA|QBUK|QBAU -->
          <Quantity>QUANTYPE</Quantity>                     <!-- opt -->
          <UnitOfMeasure>STRTYPE</UnitOfMeasure>            <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU, v7.0 -->
          <OverrideUOMSetRef>                               <!-- opt, v7.0 -->
            <ListID>IDTYPE</ListID>                         <!-- opt -->
            <FullName>STRTYPE</FullName>                    <!-- opt, max length = 31 for QBD|QBCA|QBUK|QBAU -->
          </OverrideUOMSetRef>
          <!-- BEGIN OR: You may optionally have Rate OR RatePercent -->
          <Rate>PRICETYPE</Rate>
          <!-- OR -->
          <RatePercent>PERCENTTYPE</RatePercent>
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
          <Invoiced>QUANTYPE</Invoiced>                     <!-- opt -->
          <IsManuallyClosed>BOOLTYPE</IsManuallyClosed>     <!-- opt -->
          <Other1>STRTYPE</Other1>                          <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
          <Other2>STRTYPE</Other2>                          <!-- opt, max length = 29 for QBD|QBCA|QBUK|QBAU, v6.0 -->
          <DataExtRet>                                      <!-- opt, may rep -->
            <OwnerID>GUIDTYPE</OwnerID>                     <!-- opt -->
            <DataExtName>STRTYPE</DataExtName>              <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
            <!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
            <DataExtType>ENUMTYPE</DataExtType>
            <DataExtValue>STRTYPE</DataExtValue>
          </DataExtRet>
        </SalesOrderLineRet>
        <DataExtRet>                                        <!-- opt, may rep -->
          <OwnerID>GUIDTYPE</OwnerID>                       <!-- opt -->
          <DataExtName>STRTYPE</DataExtName>                <!-- max length = 31 for QBD|QBCA|QBUK|QBAU -->
          <!-- DataExtType may have one of the following values: AMTTYPE, DATETIMETYPE, INTTYPE, PERCENTTYPE, PRICETYPE, QUANTYPE, STR1024TYPE, STR255TYPE -->
          <DataExtType>ENUMTYPE</DataExtType>
          <DataExtValue>STRTYPE</DataExtValue>
        </DataExtRet>
      </SalesOrderRet>
    </SalesOrderQueryRs>
    123456789

    SalesOrderAddRqA = <<-123456789
    <SalesOrderAddRq>
      <SalesOrderAdd>
        <CustomerRef>
          <ListID>12345</ListID>
          <FullName>Schmoe, Joe</FullName>
        </CustomerRef>
        <TxnDate>#{Date.today.strftime("%Y-%m-%d")}</TxnDate>
        <RefNumber>12345678901</RefNumber>
        <BillAddress>
          <Addr1>999 Some Rd</Addr1>
          <City>Other City</City>
          <State>TX</State>
          <PostalCode>88888</PostalCode>
        </BillAddress>
        <ShipAddress>
          <Addr1>999 Some Rd</Addr1>
          <City>Other City</City>
          <State>TX</State>
          <PostalCode>88888</PostalCode>
        </ShipAddress>
        <PONumber>99999-111-ABCDE-00000</PONumber>
        <ShipDate>#{Date.today.strftime("%Y-%m-%d")}</ShipDate>
        <Memo>This is a test SalesOrder Add request.</Memo>
        <IsToBePrinted>true</IsToBePrinted>
        <IsToBeEmailed>false</IsToBeEmailed>
        <CustomerSalesTaxCodeRef>
          <ListID>3987235</ListID>
        </CustomerSalesTaxCodeRef>
        <SalesOrderLineAdd>
          <ItemRef>
            <ListID>8887778</ListID>
          </ItemRef>
          <Desc>Some odd item</Desc>
          <Quantity>1</Quantity>
          <Rate>25.00</Rate>
          <Amount>25.00</Amount>
        </SalesOrderLineAdd>
        <SalesOrderLineAdd>
          <ItemRef>
            <ListID>8887779</ListID>
          </ItemRef>
          <Desc>Some other odd item</Desc>
          <Quantity>2</Quantity>
          <Rate>21.00</Rate>
          <Amount>42.00</Amount>
        </SalesOrderLineAdd>
      </SalesOrderAdd>
    </SalesOrderAddRq>
    123456789
    
    SalesOrderAddRsA = <<-123456789
    <SalesOrderAddRs>
      <SalesOrderRet>
        <TxnID>98769876</TxnID>
        <TimeCreated>#{Time.now.xmlschema}</TimeCreated>
        <TimeModified>#{Time.now.xmlschema}</TimeModified>
        <EditSequence>222</EditSequence>
        <CustomerRef>
          <ListID>12345</ListID>
          <FullName>Schmoe, Joe</FullName>
        </CustomerRef>
        <TxnDate>#{Date.today.strftime("%Y-%m-%d")}</TxnDate>
        <RefNumber>12345678901</RefNumber>
        <BillAddress>
          <Addr1>999 Some Rd</Addr1>
          <City>Other City</City>
          <State>TX</State>
          <PostalCode>88888</PostalCode>
        </BillAddress>
        <ShipAddress>
          <Addr1>999 Some Rd</Addr1>
          <City>Other City</City>
          <State>TX</State>
          <PostalCode>88888</PostalCode>
        </ShipAddress>
        <PONumber>99999-111-ABCDE-00000</PONumber>
        <ShipDate>#{Date.today.strftime("%Y-%m-%d")}</ShipDate>
        <Subtotal>25.00</Subtotal>
        <SalesTaxPercentage>6.0%</SalesTaxPercentage>
        <SalesTaxTotal>3.78</SalesTaxTotal>
        <TotalAmount>70.78</TotalAmount>
        <IsFullyInvoiced>true</IsFullyInvoiced>
        <Memo>This is a test SalesOrder Add request.</Memo>
        <IsToBePrinted>true</IsToBePrinted>
        <IsToBeEmailed>false</IsToBeEmailed>
        <CustomerSalesTaxCodeRef>
          <ListID>3987235</ListID>
        </CustomerSalesTaxCodeRef>
        <SalesOrderLineRet>
          <TxnLineID>55544</TxnLineID>
          <ItemRef>
            <ListID>8887778</ListID>
          </ItemRef>
          <Desc>Some odd item</Desc>
          <Quantity>1</Quantity>
          <Rate>25.00</Rate>
          <Amount>25.00</Amount>
        </SalesOrderLineRet>
        <SalesOrderLineRet>
          <TxnLineID>55545</TxnLineID>
          <ItemRef>
            <ListID>8887779</ListID>
          </ItemRef>
          <Desc>Some other odd item</Desc>
          <Quantity>2</Quantity>
          <Rate>21.00</Rate>
          <Amount>42.00</Amount>
        </SalesOrderLineRet>
      </SalesOrderRet>
    </SalesOrderAddRs>
    123456789
  end
end