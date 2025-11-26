class InsuranceRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vehicle, optional: true
end
