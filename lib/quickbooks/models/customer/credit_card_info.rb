module Quickbooks
  class CreditCardInfo < Model
    read_write :credit_card_number, :expiration_month, :expiration_year, :name_on_card, :credit_card_address, :credit_card_postal_code
  end
end
