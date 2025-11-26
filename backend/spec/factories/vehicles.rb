FactoryBot.define do
  factory :vehicle do
    association :user
    plate_number { "ABC-1234" }
    year { Date.new(2020, 1, 1) }
    price { 150000.0 }

    trait :old_year do
      year { Date.new(1979, 1, 1) }
      plate_number { "OLD-1234" }
    end

    trait :cheap do
      price { 40000.0 }
      plate_number { "CHE-1234" }
    end

    trait :no_year do
      year { nil }
      plate_number { "NOY-1234" }
    end

    trait :no_price do
      price { nil }
      plate_number { "NOP-1234" }
    end
  end
end

