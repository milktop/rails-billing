module Billable

  extend ActiveSupport::Concern

  included do
    has_many :line_items, as: :resource, dependent: :destroy
    monetize :item_total_cents
    monetize :amount_cents
    monetize :unbilled_total_cents

    unless respond_to?(:invoice)
      def invoice
        line_items.where.not(invoice_id: nil).first&.invoice
      end
    end

    # scope billable where any line item is billable
    scope :billable, -> { where(id: LineItem.billable.select(:resource_id)) }
    scope :to_be_billed, -> { where(id: LineItem.to_be_billed.select(:resource_id)) }
    
  end

  def billed?
    invoice.present?
  end
  
  def unbilled?
    !billed?
  end
  
  def billable?
    line_items.billable.any?
  end

  def to_be_billed?
    line_items.to_be_billed.any?
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