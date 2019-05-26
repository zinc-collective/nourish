class SetMembershipStatusDefault < ActiveRecord::Migration[5.2]
  def change
    Membership.where(status: :guest).update_all(status: :pending)
    change_column_default(:memberships, :status, 'pending')
  end
end
