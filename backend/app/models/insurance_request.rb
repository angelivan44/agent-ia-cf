class InsuranceRequest < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vehicle, optional: true

  before_save :copy_user_and_vehicle_data

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
