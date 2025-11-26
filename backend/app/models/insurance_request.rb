class InsuranceRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vehicle, optional: true

  before_save :copy_user_and_vehicle_data



  def validate_user_age
    if user.present? && user.birth_date.present?
      age = Date.today.year - user.birth_date.year
      unless age.between?(20, 80)
        errors.add(:base, "User must be at least 18 years old")
      end
    end
  end

  def validate_vehicle_year
    if vehicle.present? && vehicle.year.present?
      if vehicle.year < 1980
        errors.add(:base, "Vehicle year must be greater than 1980")
      end
    end
  end


  def validate_vehicle_price
    if vehicle.present? && vehicle.price.present?
      if vehicle.price < 50000
        errors.add(:base, "Vehicle price must be greater than 50000")
      end
    end
  end

  def validate_vehicle_owner
    if vehicle.present? && user.present?
      if vehicle.user != user
        errors.add(:base, "Vehicle owner must be the same as the user")
      end
    end
  end

  def calculate_security_prima
  end

  def owner_risk
    owner_risk = (1 + user.age/200)*(user.infractions*user.infractions/2)*20
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
