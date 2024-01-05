class LineItemsController < ApplicationController

  def create
    resource = find_resource
    @line_item = resource.line_items.new(line_item_params)
    if @line_item.save
      redirect_back_or_to resource, notice: 'Line item was successfully created.'
    else
      redirect_back_or_to resource, alert: @line_item.errors.full_messages.join(', ')
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:name, :unit_price, :quantity, :type, :clinic_id, :client_id)
  end
  
end
