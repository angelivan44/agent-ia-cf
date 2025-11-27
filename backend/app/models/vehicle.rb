class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :insurance_requests, dependent: :destroy

  def self.calculate_vehicle_factor(year, price)
    return 0 unless year.present? && price.present?


    age_factor = (2026 - year.to_i).to_f / 100.0
    part_a_numerator = 1 + age_factor
    part_a = (part_a_numerator ** 2) / 5
    part_b = 1 + (price.to_f / 100000.0)
    (part_a * part_b).round(2)
  end
end
