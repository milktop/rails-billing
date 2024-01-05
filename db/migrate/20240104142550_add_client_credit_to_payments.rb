class AddClientCreditToPayments < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :client_credit, foreign_key: true
  end
end
