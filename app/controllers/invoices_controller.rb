class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.order date: :desc
  end

  def show
    @invoice = Invoice.find params[:id]
    @payment = Payment.new
  end

  def create
    @resource = find_resource
    @invoice = Invoice.create_from_resource @resource
    if @invoice
      redirect_back_or_to @invoice, notice: "Invoice #{@invoice.id} created"
    else
      redirect_back_or_to @resource, alert: "Invoice could not be created"
    end
  end

end
