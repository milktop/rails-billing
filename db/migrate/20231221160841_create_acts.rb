class CreateActs < ActiveRecord::Migration[7.0]
  def change
    create_table :acts do |t|
      t.string :name, null: false
      t.integer :unit_price_cents, null: false
      t.integer :tax_rate, null: false, default: 20

      t.timestamps
    end
  end
end
