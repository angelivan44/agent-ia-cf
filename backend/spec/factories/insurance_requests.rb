FactoryBot.define do
  factory :insurance_request do
    association :user
    association :vehicle

    trait :with_custom_data do
      email { "custom@test.com" }
      vehicle_plate_number { "CUSTOM-123" }
    end
  end
end

