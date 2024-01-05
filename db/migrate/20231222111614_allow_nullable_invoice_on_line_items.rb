class AllowNullableInvoiceOnLineItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :line_items, :invoice_id, true
  end
end
