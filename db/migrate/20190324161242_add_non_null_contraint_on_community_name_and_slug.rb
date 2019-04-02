class AddNonNullContraintOnCommunityNameAndSlug < ActiveRecord::Migration[5.2]
  def change
    change_column :communities, :name, :string, null: false
    change_column :communities, :slug, :string, null: false
  end
end
