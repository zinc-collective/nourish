FactoryBot.define do

  factory :person do
    email { Faker::Internet.unique.email }
    password { SecureRandom.hex }

    trait :staff do
      staff { true }
    end
  end
end
