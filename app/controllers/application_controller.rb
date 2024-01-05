class ApplicationController < ActionController::Base

  def find_resource
    resource_type = params[:resource_type].classify.constantize
    resource_id = params[:resource_id]
    resource_type.find(resource_id)
  end
  
end
