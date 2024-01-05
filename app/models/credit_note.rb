class CreditNote < ApplicationRecord
  include Billable
  
  belongs_to :clinic
  belongs_to :client
  belongs_to :invoice, optional: true
  
  has_one :client_credit

  after_create :add_client_credit

  def invoice
    super
  end

  def redeemable?
    client_credit.present?
  end
  
  private
  
  def add_client_credit
    return unless invoice.present? && invoice.amount_paid_cents > 0
    ClientCredit.create! date: Date.today, client: client, amount_cents: invoice.amount_paid_cents, credit_note: self
  end
  
end
