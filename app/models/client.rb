class Client < ApplicationRecord
  has_many :sales, dependent: :destroy
  has_many :invoices, dependent: :nullify
  has_many :line_items, dependent: :nullify
  has_many :payments, dependent: :nullify
  has_many :client_credits, dependent: :nullify

  alias_attribute :credits, :client_credits

  monetize :total_credit_cents, :unbilled_amount_cents
  
  def unbilled_resources
    items = line_items.to_be_billed
    items.map(&:resource).uniq
  end

  # Generate a list of references for the unbilled resources, we cannot simply pass ids to invoice controller as many types of resources are involved
  def unbilled_references
    unbilled_resources.map(&:record_reference)
  end

  def unbilled_amount_cents
    line_items.to_be_billed.sum(&:gross_price_cents)
  end

  def available_credits
    client_credits.select(&:active?)
  end

  def total_credit_cents
    available_credits.sum(&:amount_remaining_cents)
  end
  
end
