class AddRedeemableFlagToCreditNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :credit_notes, :redeemable, :boolean, default: true
  end
end
