FactoryBot.define do

  factory :membership do
    name { Faker::App.name }
    email { Faker::Internet.email }
    factory :relationship do
      community
    end

    status { 'member' }
    trait :moderator do
      status { 'moderator' }
    end

    trait :member do
      status { 'member' }
    end

    trait :guest do
      status { 'guest' }
    end

    person
    community

    status_updated_at { Time.current }
  end
end