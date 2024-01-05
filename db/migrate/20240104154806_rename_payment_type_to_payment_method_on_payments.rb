class RenamePaymentTypeToPaymentMethodOnPayments < ActiveRecord::Migration[7.0]
  def change
    rename_column :payments, :payment_type, :payment_method
  end
end
