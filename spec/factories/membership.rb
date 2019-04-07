FactoryBot.define do

  factory :membership do
    name { Faker::App.unique.name }
    email { Faker::Internet.unique.email }
    factory :relationship do
      community
    end

    status { 'member' }

    trait :guest do
      status { 'guest' }
    end

    person
    community

    status_updated_at { Time.current }
  end
end