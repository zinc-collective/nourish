staff_member = Person.find_or_create_by(email: 'staff@example.com')
  .tap { |o| o.update(password: 'Password123') }
zinc_community = Community.find_or_create_by(slug: :zinc)
  .tap { |o| o.update(name: "Zinc") }
moderator =  Person.find_or_create_by(email: 'moderator@example.com')
  .tap { |o| o.update(password: 'Password123') }
moderator_membership = zinc_community.memberships.find_or_create_by(person: moderator)
  .tap { |o| o.update(status: :moderator) }
community_member = Person.find_or_create_by(email: 'member@example.com')
  .tap { |o| o.update(password: 'Password123') }
community_member_membership =
  zinc_community.memberships.find_or_create_by(person: community_member)
  .tap { |o| o.update(status: :member) }
guest_member = Person.find_or_create_by(email: 'guest@example.com')
  .tap { |o| o.update(password: "Password123") }
guest_member_membership =
  zinc_community.memberships.find_or_create_by(person: community_member)
  .tap { |o| o.update(status: :guest) }

nourish_community = Community.find_or_create_by(slug: :nourish)
  .tap { |o| o.update(name: "Nourish") }
