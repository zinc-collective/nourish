class AddStaffToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :staff, :boolean, default: false
  end
end
