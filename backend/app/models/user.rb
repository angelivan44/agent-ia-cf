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

  def valitation_error_message
    return ' el cliente es menor de 20 años no podemos venderle el seguro' if age.present? && age < 20
    return ' el cliente es mayor de 80 años no podemos venderle el seguro' if age.present? && age > 80
    return ' el cliente tiene mas de 10 infracciones no podemos venderle el seguro' if infractions.present? && infractions[:infractions] > 10
    nil
  end
end
