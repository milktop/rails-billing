class PaymentAllocation < ApplicationRecord
  belongs_to :invoice
  belongs_to :payment

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }

  monetize :amount_cents
end
