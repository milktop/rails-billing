class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.date :date, null: false
      t.integer :payment_type, null: false, default: 0
      t.references :client, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
