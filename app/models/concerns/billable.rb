module Billable

  extend ActiveSupport::Concern

  included do
    has_many :line_items, as: :resource, dependent: :destroy
    monetize :item_total_cents
    monetize :amount_cents
    monetize :unbilled_total_cents

    unless respond_to?(:invoice)
      def invoice
        return nil unless billed?
        line_items.billed.first.invoice
      end
    end
    
  end

  def billed?
    billable? && line_items.billed.count == line_items.count
  end
  
  def unbilled?
    !billed?
  end
  
  def billable?
    # unbilled? && line_items.any?
    line_items.any?
  end

  def item_total_cents
    line_items.sum(&:gross_price_cents)
  end

  def amount_cents
    item_total_cents
  end

  def unbilled_total_cents
    line_items.unbilled.sum(&:gross_price_cents)
  end

end