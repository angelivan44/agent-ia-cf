class User < ApplicationRecord
  has_many :vehicles, dependent: :destroy
  has_many :insurance_requests, dependent: :destroy
end
