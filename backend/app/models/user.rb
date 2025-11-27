class User < ApplicationRecord
  has_many :vehicles, dependent: :destroy
  has_many :insurance_requests, dependent: :destroy

  def age
    if birth_date.present?
      Date.today.year - birth_date.year
    else
      nil
    end
  end

  def infractions
    ApiInfractionsService.get_infractions(national_id)
  end

  def self.calculate_risk(age, infractions)
    return nil unless age.present? && infractions.present?

    age_factor = 1.0 + (age.to_f / 200.0)
    infractions_factor = (infractions.to_f**2) / 2.0
    base_multiplier = 20.0

    age_factor * infractions_factor * base_multiplier
  end
end
