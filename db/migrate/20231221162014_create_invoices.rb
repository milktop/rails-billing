class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.date :date, null: false
      t.date :due_date
      t.references :client, null: false, foreign_key: true
      t.references :clinic, null: false, foreign_key: true
      t.integer :net_price_cents, null: false
      t.integer :gross_price_cents, null: false
      t.integer :tax_amount_cents, null: false
      t.integer :discount_amount_cents, null: false

      t.timestamps
    end
  end
end
