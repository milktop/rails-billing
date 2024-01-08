class Invoices::PaymentsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :set_invoice

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new new_params.merge(client: @invoice.client)
    
    if maximum_amount_exceeded?
      specified_amount = number_to_currency payment_params[:amount].to_f, unit: '€', locale: :fr
      @payment.errors.add :base, "Some important error message"
      @payment.errors.add :amount, "cannot be greater than the invoice balance, #{specified_amount} was specified"
      render :new, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      if @payment.save
        @invoice.payment_allocations.create payment: @payment, amount: payment_amount
        redirect_to @invoice, notice: "Payment successfully created"
      else
        render :new, status: :unprocessable_entity
      end
    end

  end

  private
  
  def set_invoice
    @invoice = Invoice.find params[:invoice_id]
  end

  def payment_params
    params.require(:payment).permit :date, :payment_method, :amount, :notes, :client_credit_id
  end

  def new_params
    payment_params.except :amount
  end

  def maximum_amount_exceeded?
    payment_params[:amount].to_f > @invoice.balance.to_f
  end

  def credit_method_selected?
    payment_params[:payment_method] == "client_credit" && payment_params[:client_credit_id].present?
  end

  def payment_amount
    return payment_params[:amount].to_f unless credit_method_selected?
    client_credit = ClientCredit.find payment_params[:client_credit_id]
    [@invoice.balance, client_credit.amount].min.to_f
  end
  
end