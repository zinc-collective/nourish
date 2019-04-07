FactoryBot.define do

  factory :person do
    email { Faker::Internet.unique.email }
    password { SecureRandom.hex }
  end
end