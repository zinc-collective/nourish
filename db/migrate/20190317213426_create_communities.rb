class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities, id: :uuid do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :communities, :slug, unique: true
  end
end
