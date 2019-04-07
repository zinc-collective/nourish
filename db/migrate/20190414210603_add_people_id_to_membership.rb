class AddPeopleIdToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :person_id, :uuid
  end
end
