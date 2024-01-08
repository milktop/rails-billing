module ApplicationHelper

  def resource_invoice_path resource
    invoices_path(resource_type: resource.class.name, resource_id: resource.id)
  end

  def euros value
    number_to_currency value, unit: '€', locale: :fr
  end
  
end
