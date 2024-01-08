class BillsController < ApplicationController
  
  def index
    scope = params[:all] ? :billable : :to_be_billed
    @consultations = Consultation.send(scope)
    @sales = Sale.send(scope)
    @bills = @consultations + @sales
    @bills.sort_by!(&:date).reverse!
    @title = params[:all] ? 'All Bills' : 'To Be Billed'
  end

end
