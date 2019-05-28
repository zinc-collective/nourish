FactoryBot.define do

  factory :membership do
    name { Faker::App.name }
    email { Faker::Internet.email }
    person
    community

    onboarding_question_response { ['red', 'blue', 'yellow', 'green'].sample }

    status { 'member' }
    trait :moderator do
      status { 'moderator' }
    end

    trait :member do
      status { 'member' }
    end

    trait :pending do
      status { 'pending' }
    end

    status_updated_at { Time.current }
  end
end
