FactoryBot.define do

  factory :person do
    email { Faker::Internet.email }
    password { 'password' }

    trait :staff do
      staff { true }
    end
  end
end
