FactoryBot.define do

  factory :community do
    name { Faker::App.unique.name }
  end
end