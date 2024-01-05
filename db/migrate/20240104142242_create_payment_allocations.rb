class CreatePaymentAllocations < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_allocations do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :payment, null: false, foreign_key: true
      t.integer :amount_cents, null: false

      t.timestamps
    end
  end
end
