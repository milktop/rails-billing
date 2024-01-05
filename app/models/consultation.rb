class Consultation < ApplicationRecord
  include Billable
  belongs_to :clinic
  belongs_to :client
end
