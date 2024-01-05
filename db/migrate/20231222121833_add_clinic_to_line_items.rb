class AddClinicToLineItems < ActiveRecord::Migration[7.0]
  def change
    # Add clinic references allowing null values
    add_reference :line_items, :clinic, null: true, foreign_key: true

    # Patch line_items with clinic_id values referenced from resource
    LineItem.find_each do |line_item|
      line_item.update(clinic_id: line_item.resource.clinic_id)
    end

    # Change nullability of clinic_id
    change_column_null :line_items, :clinic_id, false
  end
end
