class PaymentsController < ApplicationController

  def index
    @payments = Payment.order date: :desc
  end

  def show
    @payment = Payment.find params[:id]
  end
  
end
