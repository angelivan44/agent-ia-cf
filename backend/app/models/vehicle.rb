class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :insurance_requests, dependent: :destroy
end
