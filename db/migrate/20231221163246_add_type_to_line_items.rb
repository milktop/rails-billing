class AddTypeToLineItems < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :type, :string, null: false
  end
end
