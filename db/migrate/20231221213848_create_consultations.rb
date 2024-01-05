class CreateConsultations < ActiveRecord::Migration[7.0]
  def change
    create_table :consultations do |t|
      t.date :date, null: false
      t.references :clinic, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.text :motive

      t.timestamps
    end
  end
end
