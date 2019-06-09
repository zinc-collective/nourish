task demote_membership_without_person: :environment do
  Membership.where(person: nil, status: 'member').update_all(status: 'pending')
end
