FactoryBot.define do

  factory :community do
    name { Faker::App.name }
    onboarding_question { "What is your favorite color?" }
    trait :nourish do
      name { 'Nourish' }
    end
  end
end
