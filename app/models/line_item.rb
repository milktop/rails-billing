class LineItem < ApplicationRecord
  belongs_to :clinic
  belongs_to :client
  
  belongs_to :resource, polymorphic: true
  belongs_to :invoice, optional: true
  
  monetize :unit_price_cents
  monetize :discount_amount_cents
  monetize :net_price_cents
  monetize :tax_amount_cents
  monetize :gross_price_cents
  
  alias_attribute :total_price_cents, :gross_price_cents

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price_cents, presence: true, numericality: { integer_only: true }

  scope :billed, -> { where.not(invoice_id: nil) }
  scope :unbilled, -> { where(invoice_id: nil) }

  def discount_amount_cents
    return 0 unless unit_price_cents && quantity && discount_rate
    (unit_price_cents * quantity * discount_rate / 100.0).round
  end

  def net_price_cents
    return 0 unless unit_price_cents && quantity
    (unit_price_cents * quantity) - discount_amount_cents
  end

  def tax_amount_cents
    return 0 unless net_price_cents && tax_rate
    (net_price_cents * tax_rate / 100.0).round
  end

  def gross_price_cents
    return 0 unless net_price_cents && tax_amount_cents
    net_price_cents + tax_amount_cents
  end

  def billed?
    invoice.present?
  end
  
end
