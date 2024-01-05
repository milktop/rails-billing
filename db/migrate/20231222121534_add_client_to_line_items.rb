class AddClientToLineItems < ActiveRecord::Migration[7.0]
  def change
    # Add client references allowing null values
    add_reference :line_items, :client, null: true, foreign_key: true

    # Patch line_items with client_id values referenced from resource
    LineItem.find_each do |line_item|
      line_item.update(client_id: line_item.resource.client_id)
    end

    # Change nullability of client_id
    change_column_null :line_items, :client_id, false
  end
end
