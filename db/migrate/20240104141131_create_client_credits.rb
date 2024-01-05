class CreateClientCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :client_credits do |t|
      t.date :date, null: false
      t.date :expiry_date
      t.references :client, null: false, foreign_key: true
      t.references :credit_note, foreign_key: true
      t.integer :amount_cents, null: false
      t.text :details

      t.timestamps
    end
  end
end
