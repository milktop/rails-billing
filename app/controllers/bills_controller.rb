class BillsController < ApplicationController
  def index
    @consultations = Consultation.all.select(&:billable?)
    @sales = Sale.all.select(&:billable?)
    @bills = @consultations + @sales
    @bills.sort_by!(&:date).reverse!
  end
end
