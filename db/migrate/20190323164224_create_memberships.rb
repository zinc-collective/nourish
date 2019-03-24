class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.uuid :community_id, null: false

      t.timestamps
    end
    add_index :memberships, [:name, :email, :community_id]
    add_index :memberships, [:email, :community_id], unique: true
  end
end
