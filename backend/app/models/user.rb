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
    if infractions.present?
      infractions
    else
      nil
    end
  end
end
