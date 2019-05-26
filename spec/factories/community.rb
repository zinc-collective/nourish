FactoryBot.define do

  factory :community do
    name { Faker::App.name }
    trait :nourish do
      name { 'Nourish' }
    end
  end
end
