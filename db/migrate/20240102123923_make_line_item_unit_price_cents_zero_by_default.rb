class MakeLineItemUnitPriceCentsZeroByDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :line_items, :unit_price_cents, 0
  end
end
