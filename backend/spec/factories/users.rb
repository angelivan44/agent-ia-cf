FactoryBot.define do
  factory :user do
    name { "Juan" }
    last_name { "Pérez" }
    email { "juan@example.com" }
    national_id { "12345678-9" }
    birth_date { Date.new(1985, 5, 15) }

    trait :young do
      birth_date { Date.today - 19.years }
      national_id { "11111111-1" }
      email { "young@example.com" }
    end

    trait :old do
      birth_date { Date.today - 81.years }
      national_id { "22222222-2" }
      email { "old@example.com" }
    end
  end
end

