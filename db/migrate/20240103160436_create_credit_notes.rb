class CreateCreditNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_notes do |t|
      t.date :date, null: false
      t.references :clinic, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
