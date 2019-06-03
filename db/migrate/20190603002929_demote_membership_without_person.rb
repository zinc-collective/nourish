class DemoteMembershipWithoutPerson < ActiveRecord::Migration[5.2]
  def up
    Membership.where(person: nil, status: 'member').update_all(status: 'pending')
  end

  def down
  end
end
