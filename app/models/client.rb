class Client < ApplicationRecord
  has_many :sales, dependent: :destroy
  has_many :invoices, dependent: :nullify
  has_many :line_items, dependent: :nullify

  def unbilled_resources
    items = line_items.unbilled
    items.map(&:resource).uniq
  end
  
end
