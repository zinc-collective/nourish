class AddStatusOnMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :status, :string, null: false
    add_column :memberships, :status_updated_at, :datetime, null: false
    add_index :memberships, :status
  end
end
