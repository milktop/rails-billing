class SalesController < ApplicationController

  def index
    @sales = Sale.order(date: :desc)
  end

  def show
    @sale = Sale.find params[:id]
    @line_item = ProductItem.new resource: @sale
  end
  
end
