require 'factory_bot_rails'
require 'faker'

community = FactoryBot.create(:community, name: "Zinc", slug: "zinc")

FactoryBot.create(:person, :staff, email: 'staff@example.com', password: 'Password123')

FactoryBot.create(:membership, :moderator, community: community, name: 'moderator') do |membership|
  membership.person.update(
    email: 'moderator@example.com',
    password: 'Password123'
  )
end.person

FactoryBot.create(:membership, :member, community: community, name: 'member') do |membership|
  membership.person.update(
    email: 'member@example.com',
    password: 'Password123'
  )
end.person

FactoryBot.create(:membership, :guest, community: community, name: 'guest') do |membership|
  membership.person.update(
    email: 'guest@example.com',
    password: 'Password123'
  )
end.person
