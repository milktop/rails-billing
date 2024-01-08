class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.order id: :desc
  end

  def show
    @invoice = Invoice.find params[:id]
    @payment = Payment.new
  end

  def create
    invoice_ids = Invoice.create_from_resources resources
    if invoice_ids.size == 1
      @invoice = Invoice.find invoice_ids.first
      redirect_back_or_to @invoice, notice: "Invoice #{@invoice.id} created"
    elsif invoice_ids.size > 1
      redirect_back_or_to invoices_path, notice: "Invoices #{invoice_ids.join(', ')} created"
    else
      redirect_back_or_to @resource, alert: "Invoice(s) could not be created"
    end
  end

  private

  def find_resource_from_reference reference
    return nil unless reference.present?
    resource_name, _, id = reference.rpartition("_")
    resource_type = resource_name.classify.constantize
    resource_type.find(id)
  end

  def resources
    params[:resources].map { |reference| find_resource_from_reference(reference) }
  end

end
