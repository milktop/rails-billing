class ClientCredit < ApplicationRecord
  belongs_to :client
  belongs_to :credit_note, optional: true

  has_many :payments
  has_many :payment_allocations, through: :payments
  
  validates :date, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }

  monetize :amount_cents
  monetize :amount_spent_cents
  monetize :amount_remaining_cents

  def amount_spent_cents
    payment_allocations.sum(:amount_cents)
  end

  def amount_remaining_cents
    return 0 unless amount_cents && amount_spent_cents
    amount_cents - amount_spent_cents
  end

  def spent?
    amount_remaining_cents <= 0
  end

  def unspent?
    !spent?
  end

  def expired?
    expiry_date && expiry_date < Date.today
  end

  def active?
    !expired? && unspent?
  end
  
end
