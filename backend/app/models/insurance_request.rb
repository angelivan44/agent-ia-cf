class InsuranceRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vehicle, optional: true

  before_save :copy_user_and_vehicle_data

  SECURITY_PRICE = {
    "basic" => 200,
    "medium" => 350,
    "high" => 500
  }



  def validate_user_age?
    if user.present? && user.birth_date.present?
      age = Date.today.year - user.birth_date.year
      unless age.between?(20, 80)
        return false
      end
    end
  end

  def validate_vehicle_year?
    if vehicle.present? && vehicle.year.present?
      if vehicle.year < 1980
        return false
      end
    end
  end


  def validate_vehicle_price?
    if vehicle.present? && vehicle.price.present?
      if vehicle.price < 50000
        return false
      end
    end
  end

  def validate_vehicle_owner?
    if vehicle.present? && user.present?
      if vehicle.user != user
        return false
      end
    end
  end

  
  def owner_risk
    infractions_data = user.infractions
    infractions_count = infractions_data.is_a?(Hash) ? infractions_data[:infractions] : infractions_data.to_i
    owner_risk = (1 + user.age/200)*(infractions_count**2/2)*20
    owner_risk
  end

  def vehicle_factor
    return 0 unless vehicle.present? && vehicle.year.present? && vehicle.price.present?

    year = vehicle.year.year
    price = vehicle.price
    current_year = Date.today.year

    # Parte A: Factor relacionado con la antigüedad del vehículo
    # A = ((1 + (2026 - año)/100)/5)²
    age_factor = (current_year - year) / 100.0
    part_a_numerator = 1 + age_factor
    part_a = (part_a_numerator / 5.0) ** 2

    # Parte B: Factor relacionado con el precio del vehículo
    # B = (1 + precio/100000)
    part_b = 1 + (price / 100000.0)

    # Factor del vehículo = A × B
    part_a * part_b
  end

  def vehicle_primary_factor(security_price)
    (owner_risk * (1 + vehicle_factor)) + SECURITY_PRICE[security_price]
  end

  def self.calculate_insurance_premium(risk_factor, vehicle_factor)
    (risk_factor.to_f * (1 + vehicle_factor.to_f)).round + SECURITY_PRICE["high"]
  end

  def validation_errors
    errors = []
    
    if user.present?
      user_error = user.valitation_error_message
      errors << user_error if user_error.present?
    end
    
    if vehicle.present?
      vehicle_error = vehicle.valitation_error_message
      errors << vehicle_error if vehicle_error.present?
    end
    
    errors
  end

  private

  def copy_user_and_vehicle_data
    if user.present?
      self.email ||= user.email
      self.national_id ||= user.national_id
      self.birth_date ||= user.birth_date
      self.full_name ||= "#{user.name} #{user.last_name}".strip
    end

    if vehicle.present?
      self.vehicle_plate_number ||= vehicle.plate_number
    end
  end
end
