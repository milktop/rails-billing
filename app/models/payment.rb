class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :client_credit

  has_many :payment_allocations
  has_many :invoices, through: :payment_allocations
  
  has_one :credit_note

  enum payment_method: { credit_card: 0, cash: 1, cheque: 3, transfer: 4, client_credit: 5 }
  translate_enum :payment_method
  
  monetize :amount_cents

  alias_attribute :parts, :payment_allocations
  
  def amount_cents
    payment_allocations.sum(:amount_cents)
  end

  def single?
    parts.size == 1
  end

  def multiple?
    parts.size > 1
  end

  def invoice
    return nil unless single?
    invoices.first
  end

  def settle_invoices! invoice_ids: []
    invoices = Invoice.where(id: invoice_ids)
    invoices.each do |invoice|
      invoice.settle payment: self
    end
  end

end
