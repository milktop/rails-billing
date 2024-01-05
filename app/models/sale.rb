class Sale < ApplicationRecord
  include Billable
  
  belongs_to :clinic
  belongs_to :client

  def title
    to_s + " | " + date.to_fs
  end

end
