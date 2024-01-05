class PaymentsController < ApplicationController

  def index
    @payments = Payment.order date: :desc
  end

  def show
    @payment = Payment.find params[:id]
  end

  def create
    return render :new, status: :unprocessable_entity unless is_single_payment? || is_multi_payment?
    
    @payment = Payment.new create_params
    
    return render :new, status: :unprocessable_entity unless @payment.save
    
    if is_single_payment?
      @invoice = Invoice.find payment_params[:invoice_id]
      @invoice.settle payment: @payment, amount: payment_params[:amount]
      redirect_to @invoice, notice: "Payment successfully created"
    else
      @payment.settle_invoices! invoice_ids: payment_params[:invoice_ids]
      redirect_back_or_to @payment, notice: "Payment successfully created"
    end
  end

  private

  def payment_params
    params.require(:payment).permit :date, :payment_method, :client_id, :amount, :notes, :invoice_id, invoice_ids: []
  end

  def create_params
    payment_params.except(:invoice_id, :invoice_ids, :amount)
  end

  def is_single_payment?
    payment_params[:invoice_id].present?
  end

  def is_multi_payment?
    payment_params[:invoice_ids].present?
  end
  
end
