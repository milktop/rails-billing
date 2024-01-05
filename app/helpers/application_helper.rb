module ApplicationHelper

  def resource_invoice_path resource
    invoices_path(resource_type: resource.class.name, resource_id: resource.id)
  end
  
end
