class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.integer :unit_price_cents, null: false
      t.integer :tax_rate, null: false, default: 20
      t.integer :discount_rate, null: false, default: 0
      t.references :invoice, null: false, foreign_key: true
      t.references :resource, polymorphic: true, null: false

      t.timestamps
    end
  end
end
