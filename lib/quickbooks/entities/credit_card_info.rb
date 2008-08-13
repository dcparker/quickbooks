require 'quickbooks/properties/credit_card_number'
require 'quickbooks/properties/expiration_month'
require 'quickbooks/properties/expiration_year'
require 'quickbooks/properties/name_on_card'
require 'quickbooks/properties/credit_card_address'
require 'quickbooks/properties/credit_card_postal_code'
module Quickbooks
  class CreditCardInfo < Entity
    properties CreditCardNumber[:max_length => {25 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               ExpirationMonth[:min_value => 1, :max_value => 12],
               ExpirationYear,
               NameOnCard[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               CreditCardAddress[:max_length => {41 => [:QBD, :QBCA, :QBUK, :QBAU]}],
               CreditCardPostalCode[:max_length => [41 => [:QBD, :QBCA, :QBUK, :QBAU]]]
  end
end

# <CreditCardInfo>                                    <!-- opt, not in QBOE, v3.0 -->
#   <CreditCardNumber>STRTYPE</CreditCardNumber>      <!-- opt, max length = 25 for QBD|QBCA|QBUK|QBAU -->
#   <ExpirationMonth>INTTYPE</ExpirationMonth>        <!-- opt, min value = 1, max value = 12 -->
#   <ExpirationYear>INTTYPE</ExpirationYear>          <!-- opt -->
#   <NameOnCard>STRTYPE</NameOnCard>                  <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#   <CreditCardAddress>STRTYPE</CreditCardAddress>    <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
#   <CreditCardPostalCode>STRTYPE</CreditCardPostalCode> <!-- opt, max length = 41 for QBD|QBCA|QBUK|QBAU -->
# </CreditCardInfo>
