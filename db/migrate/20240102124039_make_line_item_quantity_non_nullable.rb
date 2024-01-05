class MakeLineItemQuantityNonNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :line_items, :quantity, false
  end
end
