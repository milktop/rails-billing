class Invoice < ApplicationRecord
  belongs_to :client
  belongs_to :clinic
  
  has_many :line_items, dependent: :destroy
  has_many :payment_allocations, dependent: :destroy
  has_many :payments, through: :payment_allocations
  
  has_one :credit_note

  monetize :net_price_cents
  monetize :gross_price_cents
  monetize :tax_amount_cents
  monetize :discount_amount_cents
  monetize :amount_paid_cents
  monetize :balance_cents

  alias_attribute :parts, :payment_allocations
  alias_attribute :total, :gross_price
  
  def resources
    line_items.map(&:resource).uniq
  end
  
  def resource
    # A resource's line_items will always have the same invoice (if it exists)
    line_items.first&.resource
  end

  def amount_paid_cents
    payment_allocations.sum(:amount_cents)
  end

  def balance_cents
    return 0 unless gross_price_cents && amount_paid_cents
    gross_price_cents - amount_paid_cents
  end

  def unpayable?
    credit_note.present?
  end
  
  def paid?
    balance_cents <= 0
  end

  def part_paid?
    !paid? && amount_paid_cents > 0
  end

  def unpaid?
    !paid?
  end

  def open?
    unpaid?
  end

  def late?
    unpaid? && due_date < Date.today
  end

  def status
    return "Cancelled" if credit_note
    return "Error" if unpayable?
    return "Paid" if paid?
    return "Late" if late?
    return "Part Paid" if part_paid?
    return "Active"
  end

  def set_totals! save: true, resources: nil
    line_items = resources ? resources.map(&:line_items).flatten : self.line_items
    self.net_price_cents = line_items.map(&:net_price_cents).sum
    self.gross_price_cents = line_items.map(&:gross_price_cents).sum
    self.tax_amount_cents = line_items.map(&:tax_amount_cents).sum
    self.discount_amount_cents = line_items.map(&:discount_amount_cents).sum
    self.save! if save
  end
  
  def self.create_from_resource resource
    raise ArgumentError, "Resource must be a model" unless resource.is_a?(ApplicationRecord)
    raise StandardError, "Resource is not of a billable type" unless resource.respond_to? :billable?
    raise StandardError, "Resource is already billed" if resource.billed?
    raise StandardError, "Resource is not billable" unless resource.billable?
    
    ActiveRecord::Base.transaction do
      
      # Create the invoice
      invoice = Invoice.new

      # Set the invoice's basic information
      invoice.clinic = resource.clinic
      invoice.client = resource.client
      invoice.date = Date.today
      invoice.due_date = Date.today + 30.days

      invoice.set_totals! save: false, resources: [resource]
      
      # Save the invoice
      invoice.save!

      # Now set the line items to use this invoice
      resource.line_items.unbilled.update_all invoice_id: invoice.id

      # Return the invoice
      invoice
      
    end
    
  end

  def self.create_from_resources(resources = [])
    
    raise ArgumentError, "Resources must be an array" unless resources.is_a?(Array)
  
    grouped_resources = resources.group_by { |resource| [resource.clinic_id, resource.client_id] }
  
    invoice_ids = [] # Array to store created invoice IDs
  
    ActiveRecord::Base.transaction do
      grouped_resources.each do |(clinic_id, client_id), resources|
        # Create the invoice
        invoice = Invoice.new(clinic_id: clinic_id, client_id: client_id, 
                              date: Date.today, due_date: Date.today + 30.days)
  
        invoice.set_totals!(save: false, resources: resources)
        
        # Save the invoice
        invoice.save!
  
        # Collect the invoice ID
        invoice_ids << invoice.id
  
        # Set the line items to use this invoice
        resources.each do |resource|
          resource.line_items.unbilled.update_all(invoice_id: invoice.id)
        end
      end
    end
  
    invoice_ids # Return the collected invoice IDs
  end
  

  def issue_credit_note!
    ActiveRecord::Base.transaction do
      credit_note = CreditNote.create! invoice: self, clinic: self.clinic, client: self.client, date: Date.today
      self.line_items.each do |line_item|
        item = line_item.dup
        item.assign_attributes invoice: nil, resource: credit_note, unit_price_cents: -line_item.unit_price_cents
        item.save!
      end
      credit_note
    end
  rescue => e
    false
  end
  
end
