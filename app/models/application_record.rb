class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def identifier with_prefix: false
    body = self.class.name.titleize + " #" + self.id.to_s
    return body unless with_prefix
    "# " + body
  end

  def short_reference
    "#" + self.id.to_s
  end

  def record_reference
    [self.class.name.underscore, self.id].join "_"
  end
  
end
