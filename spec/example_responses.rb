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
        <SalesTaxTotal>1.50</SalesTaxTotal>
        <TotalAmount>26.50</TotalAmount>
        <IsFullyInvoiced>true</IsFullyInvoiced>
        <Memo>This is a test SalesOrder Add request.</Memo>
        <IsToBePrinted>true</IsToBePrinted>
        <IsToBeEmailed>false</IsToBeEmailed>
        <CustomerSalesTaxCodeRef>
          <ListID>3987235</ListID>
        </CustomerSalesTaxCodeRef>
        <SalesOrderLineRet>
          <TxnLineID>IDTYPE</TxnLineID>
          <ItemRef>
            <ListID>8887778</ListID>
          </ItemRef>
          <Desc>Some odd item</Desc>
          <Quantity>1</Quantity>
          <Rate>25.00</Rate>
          <Amount>25.00</Amount>
        </SalesOrderLineRet>
      </SalesOrderRet>
    </SalesOrderAddRs>
    123456789
  end
end